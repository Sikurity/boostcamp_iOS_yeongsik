//
//  ItemStore.swift
//  Homepwner
//
//  Created by YeongsikLee on 2017. 7. 16..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ItemStore {
    private static let fileName = "items.archive"
    
    var allItems = [Item]()
    let itemArchiveURL: URL? = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = documentsDirectories.first else {
            return nil
        }
        
        return documentDirectory.appendingPathComponent(ItemStore.fileName)
    }()
    
    init() {
        guard let path = itemArchiveURL?.path else {
            return
        }
        
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [Item] {
            allItems += archivedItems
        }
    }
    
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
    
    public func saveChanges() -> Bool {
        
        guard let filePath = itemArchiveURL?.path else {
            return false
        }
        
        let result = NSKeyedArchiver.archiveRootObject(allItems, toFile: filePath)
        if result {
            print("저장 성공, 위치 : \(filePath)")
        } else {
            print("저장 실패")
        }
        
        return result
    }
}
