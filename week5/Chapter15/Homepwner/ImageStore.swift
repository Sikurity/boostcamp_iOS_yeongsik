//
//  ImageStore.swift
//  Homepwner
//
//  Created by YeongsikLee on 2017. 7. 30..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ImageStore {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func setImage(image: UIImage, forKey key: NSString) {
        imageCache.setObject(image, forKey: key)
        
        // if let data = UIImageJPEGRepresentation(image, 0.5),
        if let data = UIImagePNGRepresentation(image), // 동메달 과제
            let imageURL = imageURLForKey(key: String(key)) {
            do {
                try data.write(to: imageURL, options: .atomicWrite)
            } catch {
                print("Write Data Failed...")
            }
        }
    }
    
    func imageForKey(key: NSString) -> UIImage? {
        // return imageCache.object(forKey: key)
        
        if let existingImage = imageCache.object(forKey: key) {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: String(key))
        
        guard let path = imageURL?.path, let imageFromDisk = UIImage(contentsOfFile: path) else {
            return nil
        }
        
        imageCache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: NSString) {
        imageCache.removeObject(forKey: key)
        
        guard let imageURL = imageURLForKey(key: String(key)) else {
            return
        }
        
        
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch let deleteError{
            print("Error : \(deleteError)")
        }
    }
    
    func imageURLForKey(key: String) -> URL? {
        
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = documentsDirectories.first else {
            return nil
        }
        
        return documentDirectory.appendingPathComponent(key)
    }
}

