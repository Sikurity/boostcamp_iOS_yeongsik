//
//  CustomUIView.swift
//  CustomUIView
//
//  Created by YeongsikLee on 2017. 7. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class CustomUIView: UIView {
    
    private var innerLabel: UILabel!
    
    private var backgroundView: UIImageView!
    
    private var currentState: UIControlState! {
        didSet {
            switch currentState {
            case UIControlState.normal:
                innerLabel.text = "Normal"      // 선택 해제 상태
                innerLabel.textColor = UIColor.yellow
                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
                backgroundView.alpha = 1.0
                
            case UIControlState.selected:
                innerLabel.text = "Selected"    // 선택 적용 상태
                innerLabel.textColor = UIColor.green
                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
                backgroundView.alpha = 1.0
                
            case UIControlState.highlighted:
                innerLabel.text = "Highlighted1" // normal -> selected 사이 상태
                innerLabel.textColor = UIColor.white
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
                backgroundView.alpha = 0.5
                
            case UIControlState.application:
                innerLabel.text = "Highlighted2" // selected -> normal 사이 상태
                innerLabel.textColor = UIColor.red
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
                backgroundView.alpha = 0.5
                
            case UIControlState.disabled:
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
                backgroundView.alpha = 0.5
                
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
            backgroundView.image = backgroundImage
        }
    }
    
    private var eventControls: [UIControlEvents:[(UIResponder, Selector)]] = [:]
    
    // UIButton의 addTarget을 모방
    func addTarget(_ target: Any?, action: Selector, for event: UIControlEvents) {
        
        /// target이 UIResponder로 치환 불가능한 경우는 처리 X
        guard let respondableTarget = target as? UIResponder else {
            return
        }
        
        if eventControls[event] != nil {
            eventControls[event]! += [(respondableTarget, action)]
        } else {
            eventControls[event] = [(respondableTarget, action)]
        }
    }
    
    func removeTarget(_ target: Any?, action: Selector, for event: UIControlEvents) {
        
        guard let respondableTarget = target as? UIResponder else {
            return
        }
        
        /// 이벤트에 등록된 (target, action)이 일치하는 컨트롤의 위치를 찾아 삭제
        if let idx = eventControls[event]?.index(where: {$0 == respondableTarget && $1 == action}) {
            eventControls[event]?.remove(at: idx)
        }
    }
    
    /// UIControl의 sendActions를 구현
    func sendActions(for event: UIControlEvents) {
        guard eventControls[event] != nil else {
            return
        }
        
        for (respondableTarget, selector) in eventControls[event]! {
            if let controllableTarget = respondableTarget as? UIControl {    // target이 자신이 아니라면, target에 sendAction
                controllableTarget.sendActions(for: event)
            } else if respondableTarget.canPerformAction(selector, withSender: nil) {
                respondableTarget.perform(selector)
            }
        }
    }
    
    /// 초기화
    func setup() {
        
        self.backgroundColor = UIColor.black
        
        let innerFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self.backgroundView = UIImageView(frame: innerFrame)
        self.addSubview(self.backgroundView)
        
        self.innerLabel = UILabel(frame: innerFrame)
        self.innerLabel.textAlignment = .center
        self.addSubview(innerLabel)
        
        //self.addTarget(self, action: #selector(didCustomViewTapped), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        //self.addTarget(self, action: #selector(didTouchUpOutside), for: .touchUpOutside)
        
        self.isEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
    
    /// Touch Down 테스트 함수
    func didCustomViewTapped() {
        print("didCustomViewTapped")
    }
    
    /// Touch Down 테스트 함수
    func didTouchUpInside() {
        print("didTouchUpInside")
    }
    
    /// Touch Down 테스트 함수
    func didTouchUpOutside() {
        print("didTouchUpOutside")
    }
}

extension UIControlEvents : Hashable {
    public var hashValue: Int {
        return Int(self.rawValue)
    }
    
    public static func ==(lhs: UIControlEvents, rhs: UIControlEvents) -> Bool {
        return lhs == rhs
    }
}
