
//  Circle.swift
//  Chapter17
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct CircleSegment {
    var center: CGPoint
    var radius: CGFloat
    var color: UIColor
}

class Circle : Strokable {
    
    var segment: CircleSegment
    
    required init(locations: [CGPoint]) {
        
        var center: CGPoint = CGPoint()
        center.x = (locations[0].x + locations[1].x) / 2
        center.y = (locations[0].y + locations[1].y) / 2
        
        let dx: CGFloat = locations[1].x - locations[0].x
        let dy: CGFloat = locations[1].y - locations[0].y
        
        let radius = sqrt(dx * dx + dy * dy) / 2
        segment = CircleSegment(center: center, radius: radius, color: UIColor.black)
    }
    
    /// 실제로 DrawView에서 그림을 화면에 그릴 때 실행 됨
    func stroke(_ lineThickness: CGFloat) {
        segment.color.setStroke()
        
        let circlePath = UIBezierPath(
            arcCenter: segment.center,
            radius: segment.radius,
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        circlePath.lineWidth = lineThickness
        
        circlePath.stroke()
    }
    
    // 은메달 과제 - 색상
    /// 손가락의 위치를 반영해 그림의 색상을 결정
    internal static func caculateColor(with data: Any) -> UIColor {
        
        guard let delta = data as? CGPoint else {
            return UIColor.black
        }
        
        let dx = delta.x
        let dy = delta.y
        let r = CGFloat(sqrt(dx * dx + dy * dy))
        
        return UIColor(red: (1 + (dx / r)) / 2, green: (1 + dy / r) / 2, blue: 0.5 + (atan(dy / dx) / CGFloat.pi), alpha: 1.0)
    }
    
    /// touchesMoved에서 손가락을 움직여 그림의 모양을 변경
    func move(locations: [CGPoint]) {
        
        if locations.count > 1 {
            var center: CGPoint = CGPoint()
            center.x = (locations[0].x + locations[1].x) / 2
            center.y = (locations[0].y + locations[1].y) / 2
            
            let dx: CGFloat = locations[1].x - locations[0].x
            let dy: CGFloat = locations[1].y - locations[0].y
            
            let radius = sqrt(dx * dx + dy * dy) / 2
            segment = CircleSegment(center: center, radius: radius, color: Circle.caculateColor(with: CGPoint(x: dx, y:dy)))
        }
    }
    
    /// touchesEnded에서 화면에서 손가락을 떼서 그림의 모양을 확정
    func finish(locations: [CGPoint]) -> Strokable {
        
        if locations.count > 1 {
            var center: CGPoint = CGPoint()
            center.x = (locations[0].x + locations[1].x) / 2
            center.y = (locations[0].y + locations[1].y) / 2
            
            let dx: CGFloat = locations[1].x - locations[0].x
            let dy: CGFloat = locations[1].y - locations[0].y
            
            let radius = sqrt(dx * dx + dy * dy) / 2
            segment = CircleSegment(center: center, radius: radius, color: Circle.caculateColor(with: CGPoint(x: dx, y: dy)))
        }
        
        return self
    }
}

