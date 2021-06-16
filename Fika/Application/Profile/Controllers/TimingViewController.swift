import UIKit

class TimingViewController: UIViewController {
    @IBOutlet private var breakFastSlot: UIView!
    @IBOutlet private var lunchSlot: UIView!
    @IBOutlet private var teaSlot: UIView!

    @IBOutlet private var finishButton: UIButton!

    let backgroundColor = UIColor(red: 250 / 255, green: 251 / 255, blue: 253 / 255, alpha: 1)
    var selectedSlots: [Timeslot] = []

    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSlots = user.preferredTimeslots
        validate()
        if selectedSlots.contains(.breakfast) {
            breakFastSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
        }

        if selectedSlots.contains(.lunch) {
            breakFastSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
        }

        if selectedSlots.contains(.tea) {
            breakFastSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
        }
        setCardBorder(card: breakFastSlot)
        setCardBorder(card: lunchSlot)
        setCardBorder(card: teaSlot)
    }

    func setCardBorder(card: UIView) {
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.systemGray5.cgColor
        card.layer.cornerRadius = 15
    }

    func validate() {
        if selectedSlots.isEmpty {
            finishButton.isHidden = true
        } else {
            finishButton.isHidden = false
        }
    }

    @IBAction private func selectBreakfast(_ sender: UITapGestureRecognizer) {
        if !selectedSlots.contains(.breakfast) {
            breakFastSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
            selectedSlots.append(.breakfast)
        } else {
            breakFastSlot.backgroundColor = backgroundColor
            guard let index = selectedSlots.firstIndex(of: .breakfast) else {
                return
            }
            selectedSlots.remove(at: index)
        }
        validate()

    }

    @IBAction private func selectLunch(_ sender: UITapGestureRecognizer) {

        if !selectedSlots.contains(.lunch) {
            lunchSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
            selectedSlots.append(.lunch)
        } else {
            lunchSlot.backgroundColor = backgroundColor
            guard let index = selectedSlots.firstIndex(of: .lunch) else {
                return
            }
            selectedSlots.remove(at: index)
        }
        validate()
    }

    @IBAction private func selectTea(_ sender: UITapGestureRecognizer) {

        if !selectedSlots.contains(.tea) {
            teaSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
            selectedSlots.append(.tea)
        } else {
            teaSlot.backgroundColor = backgroundColor
            guard let index = selectedSlots.firstIndex(of: .tea) else {
                return
            }
            selectedSlots.remove(at: index)
        }
        validate()
    }
    @IBAction func onFinish(_ sender: UIButton) {
        user = User(name: user.name, position: user.position, companyId: user.companyId, introduction: user.introduction,
                    profilePicture: user.profilePicture, preferredTimeslots: selectedSlots)

        print(user)

        // save to firebase
    }
}
