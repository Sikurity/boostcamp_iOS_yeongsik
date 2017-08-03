//
//  SignUpViewController.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 1..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkPwdTextField: UITextField!
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        checkPwdTextField.delegate = self
        tapRecognizer.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validateEmailForm(_ sender: Any) {
        
        guard let email = emailTextField.text, email != "" else {
            return
        }
        
        let emailTextColor = validateEmail(email: email) ? UIColor.black : UIColor.red
        emailTextField.textColor = emailTextColor
    }
    
    /// Dissmiss keyboard by clicking blank view of outside
    @IBAction func didTapViewForDismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    @IBAction func didTappedSignUpButton(_ sender: Any) {
        
        guard
            let email = emailTextField.text, email != "",
            let nickname = nicknameTextField.text, nickname != "",
            let password = passwordTextField.text, password != "",
            let checkPwd = checkPwdTextField.text, checkPwd != ""
        else {
            self.alertComfirmMessage(title: "모든 항목을 입력해주세요", message: "입력란에 빈 칸이 있습니다")
                
            return
        }
        
        guard validateEmail(email: email) else {
            alertComfirmMessage(title: "이메일 오류", message: "올바른 이메일이 아닙니다")
            
            return
        }
                
        guard
            password == checkPwd
        else {
            self.alertComfirmMessage(title: "비밀번호 오류", message: "암호 확인이 일치하지 않습니다")
            
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(["email": email, "password": password, "nickname": nickname]) else {
            return
        }
        appDelegate.userManager.signUp(json: jsonData) { dict in
            
            let statusCode = dict["code"] as? Int
            let message = dict["message"] as? String
            let error = dict["error"] as? Error
            
            // Callback을 통해 Present
            guard
                statusCode != 201
            else {
                let result = """
                    Code : \(statusCode!)
                    Message : \(message!)
                """
                
                self.alertComfirmMessage(title: "가입완료", message: result) {
                    self.dismiss(animated: true) {
                        
                        guard
                            let mainNC = self.appDelegate.window?.rootViewController as? UINavigationController,
                            let loginVC = mainNC.viewControllers.first as? LoginViewController
                        else {
                            return
                        }
                        
                        loginVC.emailTextField.text = email
                                
                    }
                }
                
                return
            }
            
            let result = """
                Code : \(statusCode ?? -1)
                Message : \(message ?? "Unknown Error")
                \(error ?? BoostcampAPIError.unknowned)
            """
            self.alertComfirmMessage(title: "알림", message: result)
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    /// Dismiss keyboard if "Return" clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
