//
//  SignUpCustomUIView.swift
//  LoginView
//
//  Created by YeongsikLee on 2017. 7. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SignUpCustomUIView: CustomUIView {
    
    override func setup() {
        super.setup()
        
//        self.setTitle(title: "Sign Up", for: .normal)
//        self.setTitleColor(color: UIColor.red, for: .normal)
//        self.backgroundColor = UIColor.lightGray
        self.backgroundImage = UIImage(named: "signup")
    }
    
}
