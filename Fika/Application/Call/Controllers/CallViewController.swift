import UIKit
import AgoraRtcKit

class CallViewController: UIViewController {

    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var selfCollectionView: UICollectionView!
    @IBOutlet private var otherCollectionView: UICollectionView!
    @IBOutlet private var muteButton: UIButton!
    @IBOutlet private var videoButton: UIButton!
    @IBOutlet private var hideSelfVideoButton: UIButton!
    @IBOutlet private var selfVideoConstraint: NSLayoutConstraint!

    var isSelfViewHidden = false
    var selfViewHidingTimer: Timer?

    var callId: UInt = 0 // Int based IDs for Agora
    var muted = false {
        didSet {
            muteButton.isSelected = muted
            muteButton.tintColor = muted ? ColorConstants.carminePink : ColorConstants.mediumAquamarine
        }
    }
    var cameraOff = false {
        didSet {
            videoButton.isSelected = cameraOff
            videoButton.tintColor = cameraOff ? ColorConstants.carminePink : ColorConstants.mediumAquamarine
        }
    }
    var inCall = false

    var agoraKit: AgoraRtcEngineKit?
    var channelName: String?
    var user: User?
    var otherUserId: UInt?

    var conversationStarters = [String]()
    var hasStartedConversationStarter = false
    var conversationTimer: Timer?
    var conversationIndex = 0
    @IBOutlet private var conversationLabel: UILabel!
    @IBOutlet private var conversationConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        getAgoraEngine().setChannelProfile(.communication)
        setUpVideo()
        conversationStarters = ConversationConstants.starters.shuffled()
        conversationConstraint.constant = -20
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        joinChannel(channelName: "Temporary")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leaveChannel()
    }

    private func getAgoraEngine() -> AgoraRtcEngineKit {
        if agoraKit == nil {
            agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraConstants.appId, delegate: self)
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
        getAgoraEngine().joinChannel(byToken: AgoraConstants.token, channelId: channelName,
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

    func initialiseTimer() {
        self.selfViewHidingTimer?.invalidate()
        self.selfViewHidingTimer =
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                self.isSelfViewHidden = true
                self.selfVideoConstraint.constant = -120
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                    self.hideSelfVideoButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            }
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

    @IBAction private func didTapExit(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction private func didToggleMute(_ sender: UIButton) {
        muted.toggle()
        getAgoraEngine().muteLocalAudioStream(muted)
    }

    @IBAction private func didToggleVideo(_ sender: UIButton) {
        cameraOff.toggle()
        getAgoraEngine().enableLocalVideo(!cameraOff)
    }

    @IBAction private func didTapSwitchCamera(_ sender: UIButton) {
        getAgoraEngine().switchCamera()
    }

    @IBAction private func selfViewButtonDidTap(_ sender: UIButton) {
        self.selfViewHidingTimer?.invalidate()
        isSelfViewHidden = true
        self.selfVideoConstraint.constant = 20

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.hideSelfVideoButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        } completion: { _ in
            self.initialiseTimer()
        }

    }

    @IBAction private func hideConvoButtonDidTap(_ sender: UIButton) {
        conversationTimer?.invalidate()
        self.conversationConstraint.constant = -20
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.conversationTimer = Timer.scheduledTimer(withTimeInterval: 180.0, repeats: false) { _ in
                self.conversationConstraint.constant = 100
                self.conversationLabel.text = self.conversationStarters[self.conversationIndex]
                self.conversationIndex += 1
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                    self.view.layoutIfNeeded()
                }
            }
        }
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
                hideSelfVideoButton.isHidden = false

                if !isSelfViewHidden && selfViewHidingTimer == nil {
                    initialiseTimer()
                }
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
            loadingView.isHidden = true

            if !hasStartedConversationStarter {
                self.hasStartedConversationStarter = true
                conversationTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { _ in
                    self.conversationConstraint.constant = 100
                    self.conversationLabel.text = self.conversationStarters[self.conversationIndex]
                    self.conversationIndex += 1
                    UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }

        if otherUserId == nil {
            loadingView.isHidden = false
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
