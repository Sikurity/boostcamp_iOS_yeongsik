//
//  PhotosViewController.swift
//  Chapter19
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) recent photos")
                
                if let firstPhoto = photos.first {
                    
                    self.store.fetchImage(for: firstPhoto) {
                        (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .success(image):
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                        case let .failure(error):
                            print("Error downloading image: \(error)")
                        }
                    }
                }
            case let .failure(error) :
                print("Error fetching recent photos: \(error)")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

