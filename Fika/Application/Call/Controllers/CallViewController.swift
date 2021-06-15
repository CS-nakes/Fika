import UIKit
import AgoraRtcKit

class CallViewController: UIViewController {

    @IBOutlet private var selfCollectionView: UICollectionView!
    @IBOutlet private var otherCollectionView: UICollectionView!
    @IBOutlet private var muteButton: UIButton!

    let appId = "29f941ada0484cd188769da6e7e4570e"
    let tempToken = "00629f941ada0484cd188769da6e7e4570eIABP/cKa2vT6pLg/zW7ZAK+mVxFJCsTcyzYy/U/3O3Q6O59xbhcAAAAAEAARpytrwD/KYAEAAQC/P8pg"
    var callId: UInt = 0 // Int based IDs for Agora

    var muted = false {
        didSet {
            if muted {
                muteButton.setTitle("Unmute", for: .normal)
            } else {
                muteButton.setTitle("Mute", for: .normal)
            }
        }
    }
    var inCall = false

    var agoraKit: AgoraRtcEngineKit?
    var channelName: String?
    var user: User?
    var otherUserId: UInt?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAgoraEngine().setChannelProfile(.communication)
        setUpVideo()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        guard let user = self.user else {
//            // Dismiss current screen
//            return
//        }
        joinChannel(channelName: "Temporary")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leaveChannel()
    }

    private func getAgoraEngine() -> AgoraRtcEngineKit {
        if agoraKit == nil {
            agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        }
        return agoraKit!
    }

    func setUpVideo() {
        getAgoraEngine().enableVideo()
        let configuration = AgoraVideoEncoderConfiguration(
            size: AgoraVideoDimension640x360, frameRate: .fps15, bitrate: 400,
            orientationMode: .fixedPortrait)
        getAgoraEngine().setVideoEncoderConfiguration(configuration)
    }

    func joinChannel(channelName: String) {
        getAgoraEngine().joinChannel(byToken: tempToken, channelId: channelName,
                                     info: nil, uid: callId) { [weak self] _, uid, _ in
            self?.inCall = true
            self?.callId = uid
            self?.channelName = channelName
        }
    }

    func leaveChannel() {
        getAgoraEngine().leaveChannel(nil)
        inCall = false
        otherUserId = nil
        otherCollectionView.reloadData()
        selfCollectionView.reloadData()
    }

}

// MARK: - AgoraRtcEngineDelegate

extension CallViewController: AgoraRtcEngineDelegate {

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        callId = uid
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("Joined call of uid: \(uid)")
        otherUserId = uid
        otherCollectionView.reloadData()
        selfCollectionView.reloadData()
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        if otherUserId == nil {
            return
        }
        otherUserId = nil
        otherCollectionView.reloadData()
        selfCollectionView.reloadData()
    }

}

// MARK: - IBActions

extension CallViewController {

    @IBAction private func didTapExit(_ sender: Any) {
        // Dismiss view
    }

    @IBAction private func didToggleMute(_ sender: Any) {
        muted.toggle()
        getAgoraEngine().muteLocalAudioStream(muted)
    }

    @IBAction private func didTapSwitchCamera(_ sender: Any) {
        getAgoraEngine().switchCamera()
    }

}

// MARK: - Collection Extensions

extension CallViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                              UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.selfCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelfVideoCell", for: indexPath)
            if let videoCell = cell as? VideoCollectionViewCell {
                let videoCanvas = AgoraRtcVideoCanvas()
                videoCanvas.uid = callId
                videoCanvas.view = videoCell.videoView
                videoCanvas.renderMode = .fit
                getAgoraEngine().setupLocalVideo(videoCanvas)
            }
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherVideoCell", for: indexPath)

        if let videoCell = cell as? VideoCollectionViewCell, let otherUserId = otherUserId {
            let videoCanvas = AgoraRtcVideoCanvas()
            videoCanvas.uid = otherUserId
            videoCanvas.view = videoCell.videoView
            videoCanvas.renderMode = .hidden
            getAgoraEngine().setupRemoteVideo(videoCanvas)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == otherCollectionView {
            return CGSize(width: collectionView.bounds.width,
                          height: collectionView.bounds.height)
        }

        let totalWidth = collectionView.frame.width
            - collectionView.adjustedContentInset.left
            - collectionView.adjustedContentInset.right
        let totalHeight = collectionView.frame.height
            - collectionView.adjustedContentInset.top
            - collectionView.adjustedContentInset.bottom

        return CGSize(width: totalWidth, height: totalHeight)
    }
}
