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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        idTextField.delegate = self
        pwdTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- methods
    //MARK: IBActions
    
    /// Sign In 선택
    @IBAction func signIn(_ sender: Any) {
        
        print("touch up inside - sign in")
        
        let id = idTextField.text ?? ""
        let pwd = pwdTextField.text ?? ""
        
        print("ID : \(id), PW : \(pwd)")
    }
    
    /// Sign Up 선택
    @IBAction func signUp(_ sender: Any) {
        
        print("touch up inside - sign up")
    }
    
    /// 활성화 된 키보드 없애기
    @IBAction func dismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    /// (뒤로가기) 회원가입 뷰 -> 로그인 뷰
    @IBAction func prepareForUnwindFromSignUpView(segue: UIStoryboardSegue){
        
    }
}

extension LoginViewController: UITextFieldDelegate
{
    /// Return 키를 누를 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
