//
//  SignUpViewController.swift
//  LoginView
//
//  Created by YeongsikLee on 2017. 7. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    @IBOutlet weak var introduceTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        idTextField.delegate = self
        passwordTextField.delegate = self
        confirmPwdTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- methods
    //MARK: IBActions

    @IBAction func signUpWithChekingPassword(_ sender: Any) {
        if let pwd = passwordTextField.text, let confirmPwd = confirmPwdTextField.text, !pwd.isEmpty, !confirmPwd.isEmpty, pwd == confirmPwd {
            self.dismiss(animated: true, completion: nil)
        } else {
            print("비밀번호를 다시 확인해주세요")
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        print("dismissKeyBoard")
        
        self.view.endEditing(true)
    }
    
    @IBAction func chooseProfileImage(_ sender: Any) {
        
        print("chooseProfileImage")
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
}

extension SignUpViewController: UITextFieldDelegate
{
    /// Return 키를 누를 경우 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        
        // Dismiss image picker
        picker.dismiss(animated: true, completion: nil)
    }
}
