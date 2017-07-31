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

extension Photo: Equatable {

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // 두 사진이 같은 photoID를 갖는다면, 두 사진은 같다
        return lhs.photoID == rhs.photoID
    }
}
