import UIKit

class TimingViewController: UIViewController {
    @IBOutlet private var breakFastSlot: UIView!
    @IBOutlet private var lunchSlot: UIView!
    @IBOutlet private var teaSlot: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setCardBorder(card: breakFastSlot)
        setCardBorder(card: lunchSlot)
        setCardBorder(card: teaSlot)
    }

    func setCardBorder(card: UIView) {
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.systemGray5.cgColor
        card.layer.cornerRadius = 15
    }

    func clearSelection() {
        breakFastSlot.backgroundColor = .white
        lunchSlot.backgroundColor = .white
        teaSlot.backgroundColor = .white
    }

    @IBAction private func selectBreakfast(_ sender: UITapGestureRecognizer) {
        clearSelection()
        breakFastSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
    }

    @IBAction private func selectLunch(_ sender: UITapGestureRecognizer) {
        clearSelection()
        lunchSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
    }

    @IBAction private func selectTea(_ sender: UITapGestureRecognizer) {
        clearSelection()
        teaSlot.backgroundColor = .init(red: 0, green: 1, blue: 0, alpha: 0.1)
    }
}
