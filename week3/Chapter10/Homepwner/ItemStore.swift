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
    
    public func removeItem(item: Item){
        if let index = allItems.index(of: item) {
            allItems.remove(at: index)
        }
    }
    
    public func moveItem(from fromIdx: Int, toIdx: Int)
    {
        if fromIdx == toIdx {
            return
        }
        
        let movedItem = allItems[fromIdx]
        
        allItems.remove(at: fromIdx)
        allItems.insert(movedItem, at: toIdx)
    }
}
