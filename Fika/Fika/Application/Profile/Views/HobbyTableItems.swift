//
//  HobbyTableItems.swift
//  Fika
//
//  Created by Cao Wenjie on 15/6/21.
//
//import UIKit
//
//class HobbyTableItems {
//    var items = [HobbyItem]()
//
//    let hobbies = ["Running", "Reading", "Playing sports"]
//
//    init() {
//        items = hobbies.map({ HobbyItem(name: $0) })
//    }
//}
//
//extension HobbyTableItems: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        items.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: HobbyCellView.identifier, for: indexPath) as? HobbyCellView {
//                 cell.item = items[indexPath.row] // (2)
//                 if items[indexPath.row].isSelected {
//                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none) // (3)
//                 } else {
//                    tableView.deselectRow(at: indexPath, animated: false) // (4)
//                 }
//                 return cell
//              }
//        return UITableViewCell()
//    }
//}
