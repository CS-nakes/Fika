import UIKit

class TimingViewController: UIViewController {

    @IBOutlet private var breakFastSlot: UIView!
    @IBOutlet private var lunchSlot: UIView!
    @IBOutlet private var teaSlot: UIView!

    @IBOutlet private var finishButton: UIButton!

    let selectedColor = #colorLiteral(red: 0.8901960784, green: 0.9764705882, blue: 0.9647058824, alpha: 1)

    var user = User()
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        navigationController?.delegate = self
        validate()
        if user.preferredTimeslots.contains(.breakfast) {
            breakFastSlot.backgroundColor = selectedColor
        }

        if user.preferredTimeslots.contains(.lunch) {
            lunchSlot.backgroundColor = selectedColor
        }

        if user.preferredTimeslots.contains(.tea) {
            teaSlot.backgroundColor = selectedColor
        }
    }

    func validate() {
        if user.preferredTimeslots.isEmpty {
            finishButton.isHidden = true
        } else {
            finishButton.isHidden = false
        }
    }

    @IBAction private func selectBreakfast(_ sender: UITapGestureRecognizer) {
        if !user.preferredTimeslots.contains(.breakfast) {
            breakFastSlot.backgroundColor = selectedColor
            user.preferredTimeslots.append(.breakfast)
        } else {
            breakFastSlot.backgroundColor = .white
            guard let index = user.preferredTimeslots.firstIndex(of: .breakfast) else {
                return
            }
            user.preferredTimeslots.remove(at: index)
        }
        validate()
    }

    @IBAction private func selectLunch(_ sender: UITapGestureRecognizer) {

        if !user.preferredTimeslots.contains(.lunch) {
            lunchSlot.backgroundColor = selectedColor
            user.preferredTimeslots.append(.lunch)
        } else {
            lunchSlot.backgroundColor = .white
            guard let index = user.preferredTimeslots.firstIndex(of: .lunch) else {
                return
            }
            user.preferredTimeslots.remove(at: index)
        }
        validate()
    }

    @IBAction private func selectTea(_ sender: UITapGestureRecognizer) {
        if !user.preferredTimeslots.contains(.tea) {
            teaSlot.backgroundColor = selectedColor
            user.preferredTimeslots.append(.tea)
        } else {
            teaSlot.backgroundColor = .white
            guard let index = user.preferredTimeslots.firstIndex(of: .tea) else {
                return
            }
            user.preferredTimeslots.remove(at: index)
        }
        validate()
    }

    func createUser(db: FirebaseConnection, user: User) {
        do {
            try db.createUser(user: user, completion: { (err: Error?) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("Success!")
                    self.performSegue(withIdentifier: "ToHome", sender: nil)
                }

            })
        } catch {
            print(error)
        }
    }

    @IBAction private func onFinish(_ sender: UIButton) {

        // Validate
        guard let name = user.name, let position = user.position else {
            return
        }

        if name.trimmingCharacters(in: .whitespaces).isEmpty || position.trimmingCharacters(in: .whitespaces).isEmpty ||
            user.preferredTimeslots.isEmpty {
            return
        }

        print("Validation Success")

        // Save user to firebase
        let db = FirebaseConnection()
        let compressionQuality: CGFloat = 0.3

        if let profileImage = image, let imageData = profileImage.jpegData(compressionQuality: compressionQuality) {
            db.uploadImage(image: imageData, completion: { (id: String?, _: Error?) in
                if let imageId = id {
                    print("Upload Success")
                    self.user.profilePictureId = imageId
                } else {
                    print("Upload failed")
                }

                self.createUser(db: db, user: self.user)
            })
        } else {
            createUser(db: db, user: user)
        }

    }
}

extension TimingViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ProfileViewController {
            vc.user = user
        }
    }

}
