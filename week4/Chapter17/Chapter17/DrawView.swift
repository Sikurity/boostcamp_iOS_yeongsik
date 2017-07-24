//
//  DrawView.swift
//  Chapter17
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentSegment: Strokable?
    var drawedSegments: [Strokable] = []
    
    
    // MARK: @IBInspectable 사용해보기 - CGPoint, CGSize, CGRect, UIColor, UIImage... 등 사용 가능
    
    /// 그려진 선분의 색상
//    @IBInspectable var drawedLineColor: UIColor = UIColor.black {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    /// 그리는 중인 선분의 색상
//    @IBInspectable var currentLineColor: UIColor = UIColor.red {
//        didSet {
//            setNeedsDisplay()
//        }
//    }
    
    /// 선분의 굵기
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        for segment in drawedSegments {
            segment.stroke(lineThickness)
        }
        
        currentSegment?.stroke(lineThickness)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 이벤트 순서를 확인하기 위한 로그
        print(#function)
        
        var locations: [CGPoint] = []
        for touch in touches {
            locations.append(touch.location(in: self))
        }
        
        let type: StrokableType = touches.count == 2 ? .circle : .line
        currentSegment = StrokableFactory.makeSegments(type: type, with: locations)
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 이벤트 순서를 확인하기 위한 로그
        print(#function)
        
        var locations: [CGPoint] = []
        for touch in touches {
            locations.append(touch.location(in: self))
        }
        
        currentSegment?.move(locations: locations)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 이벤트 순서를 확인하기 위한 로그
        print(#function)
        
        var locations: [CGPoint] = []
        for touch in touches {
            locations.append(touch.location(in: self))
        }
        
        guard let completeSegment = currentSegment?.finish(locations: locations) else {
            return
        }
    
        drawedSegments.append(completeSegment)
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 이벤트 순서를 확인하기 위한 로그
        print(#function)
        
        currentSegment = nil
        
        setNeedsDisplay()
    }
}
