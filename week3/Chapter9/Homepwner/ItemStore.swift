//
//  ItemStore.swift
//  Homepwner
//
//  Created by YeongsikLee on 2017. 7. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    public func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
}
