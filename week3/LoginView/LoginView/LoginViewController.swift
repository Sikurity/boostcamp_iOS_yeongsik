//
//  LoginViewController.swift
//  LoginView
//
//  Created by YeongsikLee on 2017. 7. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet var recognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        idTextField.delegate = self
        pwdTextField.delegate = self
        
        // true -> TabGestureRecognizer가 커스텀 버튼의 touchesEnded 실행을 막음
        recognizer.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- methods
    //MARK: IBActions
    
    /// Click "Sign In" button to login
    @IBAction func didTabSignIn(_ sender: Any) {
        
        print("touch up inside - sign in")
        
        let id = idTextField.text ?? ""
        let pwd = pwdTextField.text ?? ""
        
        print("ID : \(id), PW : \(pwd)")
    }
    
    /// Click "Sign Up" button to sign up
    @IBAction func didTabSignUp(_ sender: Any) {
        
        print("touch up inside - sign up")
    }
    
    /// Dissmiss keyboard by clicking blank view of outside
    @IBAction func didTabViewForDismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    @IBAction func prepareForUnwindFromSignUpView(segue: UIStoryboardSegue){
        
    }
}

extension LoginViewController: UITextFieldDelegate
{
    /// Dismiss keyboard if "Return" clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
