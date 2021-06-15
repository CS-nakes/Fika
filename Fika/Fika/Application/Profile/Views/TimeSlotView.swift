//
//  TimeSlotView.swift
//  Fika
//
//  Created by Cao Wenjie on 15/6/21.
//
//import UIKit
//import Foundation
//
//class TimeSlotView: UIView {
//
//    @IBOutlet weak var contentView: UIView!
//    @IBOutlet weak var subtitleLabel: UILabel!
//    @IBOutlet weak var titleLabel: UILabel!
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initSubviews()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initSubviews()
//    }
//
//    func initSubviews() {
//        // standard initialization logic
////        let bundle = Bundle(for: TimeSlotView.self)
////        let nib = UINib(nibName: "TimeSlotView", bundle: bundle)
////        let view = nib.instantiate(withOwner: self, options: nil)[0] as? TimeSlotView
////        contentView.frame = bounds
////        contentView.layer.borderWidth = 1
////        contentView.layer.borderColor = UIColor.systemGray5.cgColor
////        contentView.layer.cornerRadius = 6
////        titleLabel.text = title
////        subtitleLabel.text = subtitle
////        guard let view = view else {
////            return
////        }
////        addSubview(view)
//    }
//
//    func onSelect() {
//        contentView.backgroundColor = .orange
//        subtitleLabel.textColor = .green
//        titleLabel.textColor = .green
//    }
//
//    func onDeselect() {
//        contentView.backgroundColor = .white
//        subtitleLabel.textColor = .lightGray
//        titleLabel.textColor = .black
//    }
//
//    @IBInspectable
//    var title: String? {
//        get {
//            titleLabel?.text
//        }
//
//        set {
//            titleLabel.text = newValue
//        }
//    }
//
//    @IBInspectable
//    var subtitle: String? {
//        get {
//            subtitleLabel?.text
//        }
//
//        set {
//            subtitleLabel.text = newValue
//        }
//    }
//}
