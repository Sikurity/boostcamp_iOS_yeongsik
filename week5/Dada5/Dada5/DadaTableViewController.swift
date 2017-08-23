//
//  DadaTableViewController.swift
//  Dada5
//
//  Created by YeongsikLee on 2017. 8. 3..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class Contact {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    
    init(_ firstName: String, _ lastName: String, _ phoneNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}

class DadaTableViewController: UITableViewController {
    
    var contacts: [String:[Contact]] = [
        "J": [Contact("jaeho", "jung", "01023456789")],
        "K": [Contact("Dadong", "Kim", "01098765432")],
        "O": [Contact("Hyungjun", "Oh", "01073784383")],
        "P": [Contact("Hyunmin", "Park", "01043922111")],
        "S": [Contact("Daigeun", "Sohn", "01029388282")]
    ]
    
    var firstLetters :[String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contacts.sorted { $0.0 < $1.0 }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        firstLetters = []
        
        for (key, _) in contacts {
            firstLetters?.append(key)
        }
        
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return firstLetters?[section]
    }
    
    @IBAction func unwindFromVC(segue: UIStoryboardSegue) {
        guard
            let vc = segue.source as? AddContactViewController,
            let newContact = vc.contact,
            let firstLetter = newContact.lastName.first
        else {
            return
        }
        
        if contacts[String(firstLetter)] == nil {
           contacts[String(firstLetter)] = [newContact]
        } else {
           contacts[String(firstLetter)]?.append(contentsOf: [newContact])
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
