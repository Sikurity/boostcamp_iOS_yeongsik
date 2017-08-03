//
//  LoginViewController.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 1..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        tapRecognizer.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Dissmiss keyboard by clicking blank view of outside
    @IBAction func didTapViewForDismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "loginSegue" {
            
            guard
                let email = emailTextField.text, email != "",
                let password = passwordTextField.text, password != ""
            else {
                alertComfirmMessage(title: "입력값 오류", message: "아이디와 패스워드에 빈 칸이 있습니다")
                
                return false
            }
            
            guard validateEmail(email: email) else {
                alertComfirmMessage(title: "이메일 오류", message: "올바른 이메일이 아닙니다")
                
                return false
            }
            
            guard let jsonData = try? JSONEncoder().encode(["email": email, "password": password]) else {
                return false
            }
            
            appDelegate.userManager.login(json: jsonData) { dict in
                
                let statusCode = dict["code"] as? Int
                let message = dict["message"] as? String
                let error = dict["error"] as? Error
                
                // Callback을 통해 Present
                guard statusCode == 200 else {
                    
                    let result = """
                    Code : \(statusCode ?? -1)\n
                    Message : \(message ?? "Unknown Error")\n
                    \(error ?? BoostcampAPIError.unknowned)
                    """
                    
                    self.alertComfirmMessage(title: "알림", message: result)
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSegue", sender: sender)
                }
            }
            
            return false
        }
        
        if identifier == "signupSegue" {
            return true
        }
        
        return false
    }
}


extension LoginViewController: UITextFieldDelegate {
    /// Dismiss keyboard if "Return" clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
