//
//  CustomUIView.swift
//  CustomUIView
//
//  Created by YeongsikLee on 2017. 7. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import NotificationCenter

class CustomUIView: UIView {

    private var innerLabel: UILabel!
    private var titles: [UInt:String?] = [
        UIControlState.normal.rawValue: nil,
        UIControlState.selected.rawValue: nil,
        UIControlState.highlighted.rawValue: nil,
        UIControlState.application.rawValue: nil
    ]
    
    private var titleColors: [UInt:UIColor?] = [
        UIControlState.normal.rawValue: nil,
        UIControlState.selected.rawValue: nil,
        UIControlState.highlighted.rawValue: nil,
        UIControlState.application.rawValue: nil
    ]
    
    private var backgroundImageView: UIImageView!
    
    private var currentState: UIControlState! {
        didSet {
            
            innerLabel.text = titles[currentState.rawValue]! ?? titles[UIControlState.normal.rawValue]!
            innerLabel.textColor = titleColors[currentState.rawValue]! ?? titleColors[UIControlState.normal.rawValue]!
            
            switch currentState {
            case UIControlState.normal: fallthrough         // 선택 해제 상태
            case UIControlState.selected:                   // 선택 적용 상태

                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
                backgroundImageView.alpha = 1.0
                
            case UIControlState.highlighted: fallthrough    // normal -> selected 사이 상태
            case UIControlState.application: fallthrough    // selected -> normal 사이 상태
            case UIControlState.disabled:
                
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
                backgroundImageView.alpha = 0.5
                
            default:
                break
            }
        }
    }
    
    /// 비활성화 -> 활성화 시 비활성화 이전 상태를 저장, 초기화에도 이용 됨
    private var savedState: UIControlState = .normal
    public var isEnabled: Bool! {
        didSet(prevState) {
            if isEnabled {
                currentState = savedState       // 비활성화 되기 이전 상태로 복구
            } else {
                savedState = currentState       // 비활성화 되기 이전 상태를 저장
                currentState = .disabled
            }
            
            isUserInteractionEnabled = isEnabled
        }
    }
    
    /// 버튼 사용 가능한 경우 백그라운드 이미지
    public var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    
    private var eventControls: [UIControlEvents.RawValue:[(UIResponder, Selector)]] = [:]
    
    // UIButton의 addTarget을 모방
    public func addTarget(_ target: Any?, action: Selector, for event: UIControlEvents) {
        
        /// target이 UIResponder로 치환 불가능한 경우는 처리 X
        guard let respondableTarget = target as? UIResponder else {
            return
        }
        
        if eventControls[event.rawValue] != nil {
            eventControls[event.rawValue]! += [(respondableTarget, action)]
        } else {
            eventControls[event.rawValue] = [(respondableTarget, action)]
        }
    }
    
    public func removeTarget(_ target: Any?, action: Selector, for event: UIControlEvents) {
        
        guard let respondableTarget = target as? UIResponder else {
            return
        }
        
        /// 이벤트에 등록된 (target, action)이 일치하는 컨트롤의 위치를 찾아 삭제
        if let idx = eventControls[event.rawValue]?.index(where: {$0 == respondableTarget && $1 == action}) {
            eventControls[event.rawValue]?.remove(at: idx)
        }
    }
    
    /// UIControl의 sendActions를 구현
    public func sendActions(for event: UIControlEvents) {
        guard eventControls[event.rawValue] != nil else {
            return
        }
        
        for (respondableTarget, selector) in eventControls[event.rawValue]! {
            if let controllableTarget = respondableTarget as? UIControl {    // target이 자신이 아니라면, target에 sendAction
                controllableTarget.sendActions(for: event)
            } else if respondableTarget.canPerformAction(selector, withSender: nil) {
                respondableTarget.perform(selector)
            }
        }
    }
    
    public func setTitle(title: String?, for state: UIControlState) {
        
        titles[state.rawValue] = title
    }
    
    public func setTitleColor(color: UIColor?, for state: UIControlState) {
        titleColors[state.rawValue] = color
    }
    
    /// 초기화
    public func setup() {
        let innerFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.backgroundImageView = UIImageView(frame: innerFrame)
        self.addSubview(backgroundImageView)
        
        self.innerLabel = UILabel(frame: innerFrame)
        self.innerLabel.textAlignment = .center     // FIXME: 중앙 정렬 적용 안됨, 원인 파악 중...
        self.addSubview(innerLabel)
    }
    
    private func didSetupEnded() {
        
        
        self.isEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        didSetupEnded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        didSetupEnded()
    }
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        switch currentState {
        case UIControlState.normal:         // normal -> highlighted1
            currentState = UIControlState.highlighted
        case UIControlState.selected:       // selected -> highlighted2
            currentState = UIControlState.application
        default:
            
            print("Something wrong... maybe gesture recognizer ate touch began event")
            break
        }
        
        sendActions(for: .touchDown)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        switch currentState {
        case UIControlState.highlighted:    // highlighted1 -> selected
            currentState = UIControlState.selected
        case UIControlState.application:    // highlighted2 -> normal
            currentState = UIControlState.normal
        default:
            print("Something wrong... maybe gesture recognizer ate touch ended event")
            break
        }
        
        guard let location = touches.first?.location(in: self) else {
            return  // something wrong...
        }
        
        if 0 <= location.x && location.x <= self.frame.width && 0 <= location.y && location.y <= self.frame.height {
            sendActions(for: .touchUpInside)    // 터치가 버튼 안에서 끝나면 touchUpInside
        } else {
            sendActions(for: .touchUpOutside)   // 터치가 버튼 밖에서 끝나면 touchUpOutside
        }
    }
}
