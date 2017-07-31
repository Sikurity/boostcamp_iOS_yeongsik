//
//  Record.swift
//  Game1to25
//
//  Created by YeongsikLee on 2017. 7. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

class Record : NSObject, NSCoding {
    
    var name: String
    var playtime: String
    var date: Date
    
    init(name: String, playtime: String, date: Date)
    {
        self.name = name
        self.playtime = playtime
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey:"name") as! String
        self.playtime = aDecoder.decodeObject(forKey:"playtime") as! String
        self.date = aDecoder.decodeObject(forKey:"date") as! Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey:"name")
        aCoder.encode(self.playtime, forKey:"playtime")
        aCoder.encode(self.date, forKey:"date")
    }

}
