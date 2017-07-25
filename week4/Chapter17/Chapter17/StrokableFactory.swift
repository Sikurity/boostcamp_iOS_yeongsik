//
//  StrokableFactory.swift
//  Chapter17
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import UIKit

enum StrokableType {
    case circle
    case line
}

class StrokableFactory {
    
    /// 터치된 손가락의 개수에 따라 결정된 타입의 객체를 생성해 반환
    static func makeSegments(type: StrokableType, with locations:[CGPoint]) -> Strokable {
        
        switch type {
            case .line:
                return Line(locations: locations)
            case .circle:
                return Circle(locations: locations)
        }
    }
    
}
