//
//  User.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var _id: String
    var nickname: String
    var password: String
    var email: String
    var __v: Int
    
    init?(json: [String: Any]) {
        guard
            let _id = json["_id"] as? String,
            let nickname = json["nickname"] as? String,
            let password = json["password"] as? String,
            let email = json["email"] as? String,
            let __v = json["__v"] as? Int
        else {
            return nil
        }
        
        /// id는 nil이어서는 안되므로, nil일 경우 에러를 유발하기 위해 ! 사용
        self._id = _id
        self.nickname = nickname
        self.password = password
        self.email = email
        self.__v = __v
    }
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        // 두 게시물이 같은 ID를 갖는다면, 두 게시물은 같다
        return lhs._id == rhs._id
    }
}
