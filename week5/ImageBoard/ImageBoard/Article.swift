//
//  Article.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

struct Article: Codable {
    
    var _id: String
    var created_at: Int
    var thumb_image_url: String
    var image_url: String
    var author_nickname: String?
    var author: String
    var image_desc: String
    var image_title: String
    var __v: Int
    
    init?(json: [String: Any]) {
        guard
            let _id = json["_id"] as? String,
            let created_at = json["created_at"] as? Int,
            let thumb_image_url = json["thumb_image_url"] as? String,
            let image_url = json["image_url"] as? String,
            let author_nickname = json["author_nickname"] as? String,
            let author = json["author"] as? String,
            let image_desc = json["image_desc"] as? String,
            let image_title = json["image_title"] as? String,
            let __v = json["__v"] as? Int
        else {
            return nil
        }
        
        self._id = _id
        self.created_at = created_at
        self.thumb_image_url = thumb_image_url
        self.image_url = image_url
        self.author_nickname = author_nickname
        self.author = author
        self.image_desc = image_desc
        self.image_title = image_title
        self.__v = __v
    }
}

extension Article: Equatable {

    static func == (lhs: Article, rhs: Article) -> Bool {
        // 두 게시물이 같은 ID를 갖는다면, 두 게시물은 같다
        return lhs._id == rhs._id
    }
}
