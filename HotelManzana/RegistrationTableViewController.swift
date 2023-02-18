//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Антон Шалимов on 16.02.2023.
//

import UIKit

class RegistrationTableViewController: UITableViewController, AddRegistrationViewControllerDelegate {
    func addRegistrationViewController(_ controller: AddRegistrationTableViewController, didSave registration: Registration)
    {
        if let indexPath = tableView.indexPathForSelectedRow {
            registraions.remove(at: indexPath.row)
            registraions.insert(registration, at: indexPath.row)
        } else {
            registraions.append(registration)
        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Properties
    var registraions: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registraions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registraions[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName + " " + registration.lastName
        content.secondaryText = (
            registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + ": " + registration.roomType.name
        cell.contentConfiguration = content
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Segues actions
    // Unwind segue
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
        // Guarding that unwind was from the ARTVC and registration there was set
        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
              let registration = addRegistrationTableViewController.registration else { return }
        // Appending new registraion from ARTVC
        registraions.append(registration)
        // Reloading table data
        tableView.reloadData()
    }
    
    @IBSegueAction func viewRegistrationDetails(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        let detailViewController = AddRegistrationTableViewController(coder: coder)
        detailViewController?.delegate = self
        
        guard
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell)
        else {
            print("----Empty data----")
            return detailViewController
        }
        print("----Get registration----")
        
        let registration = registraions[indexPath.row]
        print("----Registration----")
        print(registration)
        detailViewController?.initialRegistration = registration
        
        return detailViewController
    }
    
}
