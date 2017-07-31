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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀 내용에 맞게 셀의 높이를 조절하도록 변경
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        let newItem = itemStore.createItem()
        
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
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
    
    ///
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
        
        cell.updateLabels()
        
        let item: Item = itemStore.allItems[indexPath.row]
        
        // 동매달 과제 - 셀 색상
        let color = (item.valueInDollars < 50) ? UIColor.green : UIColor.red
        cell.backgroundColor = color
        
        cell.nameLabel?.text = item.name
        cell.serialNumberLabel?.text = item.serialNumber
        cell.valueLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    /// 편집 모드에서 스와이프 시 나타나는 삭제 버튼을 커스터마이징
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
    
    /// 편집 모드에서 우측 이동버튼을 누른채 드래그하여 이동
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        itemStore.moveItem(from: sourceIndexPath.row, toIdx: destinationIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            
            // 방금 어느 행이 눌렸는지 계산
            if let row = tableView.indexPathForSelectedRow?.row {
                
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                
                detailViewController.item = item
            }
        }
    }
}
