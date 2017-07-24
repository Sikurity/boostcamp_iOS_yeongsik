//
//  SignInCustomUIView.swift
//  LoginView
//
//  Created by YeongsikLee on 2017. 7. 18..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SignInCustomUIView: CustomUIView {
    
    override func setup() {
        super.setup()
        
        //self.setTitle(title: "Sign In", for: .normal)
        //self.setTitleColor(color: UIColor.white, for: .normal)
        //self.backgroundColor = UIColor.green
        self.backgroundImage = UIImage(named: "signin")
    }

}
