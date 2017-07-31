//
//  Photo.swift
//  Chapter19
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class Photo {
    
    let photoID: String
    let title: String
    let remoteURL: URL
    let dateTaken: Date
    var image: UIImage?
    
    init(photoID: String, title: String, remoteURL: URL, dateTaken: Date) {
        
        self.photoID = photoID
        self.title = title
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}
