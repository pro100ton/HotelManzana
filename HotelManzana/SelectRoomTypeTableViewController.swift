//
//  SelectRoomTypeTableViewController.swift
//  HotelManzana
//
//  Created by Антон Шалимов on 13.02.2023.
//

import UIKit

class SelectRoomTypeTableViewController: UITableViewController {
    
    // MARK: Variables
    
    var roomType: RoomType?
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Table view data source
    
    /// Overriding delegate Table View method for setting up number of sections in table view
    /// - Parameter tableView: self table view element
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Overriding number of rows on section delegate method for setting up amount of rows in section
    /// - Parameters:
    ///   - tableView: tableView object
    ///   - section: amount of rows for each section
    /// - Returns: number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = roomType.name
        content.secondaryText = "\(roomType.price)$"
        cell.contentConfiguration = content
        // Adding checkmark for selected by user row
        // If room type of cell in row equals selected by `didSelectRowAt`
        if roomType == self.roomType {
            // Place check as an accessory of a row
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    /// Overriding `didSelectRow` method delegate
    /// - Parameters:
    ///   - tableView: current table view object
    ///   - indexPath: index path of an object
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselecting row that user tapped
        tableView.deselectRow(at: indexPath, animated: true)
        // Getting Room type by accessing index path of row, that user tapped
        let roomType = RoomType.all[indexPath.row]
        self.roomType = roomType
        delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
        // Reloading table view data
        tableView.reloadData()
    }
}

protocol SelectRoomTypeTableViewControllerDelegate: AnyObject {
    // This function is equal to definition from the book, that stands: "selectRoomTypeTableViewController(_:didSelect:) that takes in two parameters: the SelectRoomTypeTableViewController and a RoomType instance."
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

