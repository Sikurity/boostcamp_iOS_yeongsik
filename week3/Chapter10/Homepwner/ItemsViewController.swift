//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by YeongsikLee on 2017. 7. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        // 은메달 과제: 고정 행 - Main.storyboard에서 TableView에 cell아래 UIView를 추가해서 해결
    }
    
    @IBAction func toggleEditingMode(_ sender: AnyObject) {
        let title: String = isEditing ? "Edit" : "Done"
        
        sender.setTitle(title, for: .normal)
        setEditing(!isEditing, animated: true)
    }
    
    
    @IBAction func addNewItem(_ sender: Any) {
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        let item: Item = itemStore.allItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let removeButton = UITableViewRowAction(style: .destructive, title: "Remove") { _, indexPath in
            
            let item = self.itemStore.allItems[indexPath.row]
            
            let title = "Remove \(item.name)?"
            let msg = "Are you sure about that?"
            
            
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
                
                self.itemStore.removeItem(item: item)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alertController.addAction(removeAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        removeButton.backgroundColor = UIColor.red
        
        return [removeButton]
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        itemStore.moveItem(from: sourceIndexPath.row, toIdx: destinationIndexPath.row)
    }
    
}
