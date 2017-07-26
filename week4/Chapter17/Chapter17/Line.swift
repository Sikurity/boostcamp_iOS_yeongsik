//
//  Line.swift
//  Chapter17
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import UIKit

// 구조체는 상속을 지원하지 않는다
// 구조체는 초기화 선언이 없으면 기본적으로 멤버 단위 초기화 함수와 빈 초기화 함수를 제공한다
// 모든 프로퍼티는 기본적으로 기본 값을 갖는다
// 구조체는 값 타입, 클래스는 참조 타입

struct LineSegment {
    var begin: CGPoint
    var end: CGPoint
    var color: UIColor
}

class Line : Strokable{
    
    var segments:[LineSegment] = []
    
    required init(locations: [CGPoint]) {
        
        for location in locations {
            segments.append(LineSegment(begin: location, end: location, color: UIColor.black))
        }
    }
    
    /// 실제로 DrawView에서 그림을 화면에 그릴 때 실행 됨
    func stroke(_ lineThickness: CGFloat) {
        
        for segment in segments {
            segment.color.setStroke()
            
            let path = UIBezierPath()
            
            path.lineWidth = lineThickness
            path.lineCapStyle = .round
            
            path.move(to: segment.begin)
            path.addLine(to: segment.end)
            
            path.stroke()
        }
    }
    
    // 은메달 과제 - 색상
    /// 손가락의 위치를 반영해 그림의 색상을 결정
    internal static func caculateColor(with data: Any) -> UIColor {
        
        guard let line = data as? LineSegment else {
            return UIColor.black
        }
        
        let begin = line.begin
        let end  = line.end
        
        let dx = abs(end.x - begin.x)
        let dy = abs(end.y - begin.y)
        let r = CGFloat(sqrt(Double(dx * dx + dy * dy)))
        
        return UIColor(red: (1 + (dx / r)) / 2, green: (1 + dy / r) / 2, blue: 0.5 + (atan(dy / dx) / CGFloat.pi), alpha: 1.0)
    }
    
    /// touchesMoved에서 손가락을 움직여 그림의 모양을 변경
    func move(locations: [CGPoint]) {
        
        for (idx, location) in locations.enumerated() {
            
            if idx < segments.count {
                segments[idx].end = location
                segments[idx].color = Line.caculateColor(with: segments[idx])
            } else {
                break
            }
        }
    }
    
    /// touchesEnded에서 화면에서 손가락을 떼서 그림의 모양을 확정
    func finish(locations: [CGPoint]) -> Strokable {
        
        for (idx, location) in locations.enumerated() {
            
            if idx < segments.count {
                segments[idx].end = location
                segments[idx].color = Line.caculateColor(with: segments[idx])
            } else {
                break
            }
        }
        
        return self
    }
}
