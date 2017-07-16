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
    var itemsGreaterThan50: [Item] = []
    var itemsLessThan50: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        /// 금메달 과제: 테이블 커스터마이징
        let backgroundImage = UIImage(named: "boostcamp")
        let imageView = UIImageView(image: backgroundImage)
        
        tableView.backgroundView = imageView
        
        // 은메달 과제: 고정 행 - Main.storyboard에서 TableView에 cell아래 UIView를 추가해서 해결
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var count: Int
        
        /// 동메달 과제: 멀티 섹션
        if section == 0 {
            itemsGreaterThan50 = itemStore.allItems.filter{ $0.valueInDollars > 50 }.sorted{ $0.valueInDollars < $1.valueInDollars }
            count = itemsGreaterThan50.count
        } else {
            itemsLessThan50 = itemStore.allItems.filter{ $0.valueInDollars <= 50 }.sorted{ $0.valueInDollars < $1.valueInDollars }
            count = itemsLessThan50.count
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)

        var item: Item
        
        /// 동메달 과제: 멀티 섹션
        if indexPath.section == 0 {
            item = itemsGreaterThan50[indexPath.row]
        } else {
            item = itemsLessThan50[indexPath.row]
        }
        
        /// 금메달 과제: 테이블 커스터마이징
        if indexPath.section < 1 || indexPath.row != (itemsLessThan50.count - 1) {
            let font = UIFont.systemFont(ofSize: 20.0)
            cell.textLabel?.font = font
            cell.detailTextLabel?.font = font
        }
        
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    /// 금메달 과제: 테이블 커스터마이징
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section == 1 && indexPath.row == (itemsLessThan50.count - 1)  else {
            return 60.0
        }
        
        return 44.0
    }
    
    /// 금메달 과제: 테이블 커스터마이징
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44.0
    }
    
    /// 동메달 과제: 멀티 섹션
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "Greater than $50" : "Less than $50"
    }
}
