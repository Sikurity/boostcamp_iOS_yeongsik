//
//  Strokable.swift
//  Chapter17
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import UIKit

protocol Strokable {
    
    init(locations: [CGPoint])                      /// 터치 위치 정보를 이용해 초기화
    
    func stroke(_ lineThickness: CGFloat)           /// 화면에 실제로 그림 그리기
    
    func move(locations: [CGPoint])                 /// 손가락 위치 변경 시 그림 모양 변경
    func finish(locations: [CGPoint]) -> Strokable  /// 손가락을 화면에서 뗄 경우 그림 모양 확정
    
    static func caculateColor(with data: Any) -> UIColor  /// 그림 색상 결정
}
