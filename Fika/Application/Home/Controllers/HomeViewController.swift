import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var positionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var selfImageView: UIImageView!
    @IBOutlet private var otherImageView: UIImageView!
    @IBOutlet private var quoteLabel: UILabel!

    var sessionId = "SESSION_ID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        // Clear all "past controllers".
        guard let navigationController = self.navigationController else {
            return
        }
        var navigationArray = navigationController.viewControllers
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!)
        self.navigationController?.viewControllers = navigationArray

        quoteLabel.text = StringConstants.quotes.randomElement()
        loadSelf()
        loadSession()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CallViewController {
            vc.sessionId = sessionId
        }
    }

    func loadSelf() {
        guard let profileImageId: String = UserRepository.readValue(forKey: "profilePictureId") else {
            return
        }
        FirebaseConnection().fetchImage(name: profileImageId) { data, error in
            guard error == nil, let data = data else {
                return
            }
            self.selfImageView.image = UIImage(data: data)
        }
    }

    func loadSession() {
        // swiftlint:disable:next closure_body_length
        FirebaseConnection().upcomingSessionsListener { sessions, error in
            guard error == nil, let session = sessions?.first, let sessionId = session.id,
                  let userId: String = UserRepository.readValue(forKey: "userId"),
                  let participantId = session.participants.first(where: { $0 != userId }) else {
                return
            }

            self.sessionId = sessionId
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMMM, E"

            FirebaseConnection().fetchUser(userId: participantId) { otherUser, error in
                guard error == nil, let otherUser = otherUser else {
                    return
                }

                let setUserAttributes = {
                    self.nameLabel.text = otherUser.name
                    self.positionLabel.text = otherUser.position
                    self.dateLabel.text = dateFormatter.string(from: session.date)
                    self.timeLabel.text = session.timeslot.rangeString
                }

                if let profilePictureId = otherUser.profilePictureId {
                    FirebaseConnection().fetchImage(name: profilePictureId) { data, error in
                        guard error == nil, let data = data else {
                            setUserAttributes()
                            return
                        }
                        self.otherImageView.image = UIImage(data: data)
                        setUserAttributes()
                    }
                } else {
                    setUserAttributes()
                }
            }
        }
    }
}
