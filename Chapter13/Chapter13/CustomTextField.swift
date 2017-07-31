//
//  CustomTextField.swift
//  Chapter13
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

/// 은메달 과제: UITextField 사용자화
class CustomTextField: UITextField {
    
    /// 최상위 응답객체가 되면 테두리를 변경
    override func becomeFirstResponder() -> Bool {
        
        self.borderStyle = .bezel
        super.becomeFirstResponder()
        
        return true
    }

    /// 최상위 응답객체가 아니게 되면 테두리를 원형 테두리로 되돌림
    override func resignFirstResponder() -> Bool {
        
        self.borderStyle = .roundedRect
        super.resignFirstResponder()
        
        return true
    }
}
