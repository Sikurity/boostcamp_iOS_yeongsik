//
//  ViewController.swift
//  LoginView
//
//  Created by YeongsikLee on 2017. 7. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBAction func signIn(_ sender: Any) {
        print("touch up inside - sign in")
        
        let id = idTextField.text ?? ""
        let pwd = pwdTextField.text ?? ""
        
        print("ID : \(id), PW : \(pwd)")
    }
    
    @IBAction func signUp(_ sender: Any) {
        print("touch up inside - sign up")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
