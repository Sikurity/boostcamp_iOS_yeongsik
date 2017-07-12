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

    /// Click "Sign Up" button for registering
    @IBAction func didTabSignUp(_ sender: Any) {
        
        if vaildatePassword(passwordTextField.text, confirmPwdTextField.text) {
            self.dismiss(animated: true, completion: nil)
        } else {
            print("비밀번호를 확인해주세요")
        }
    }
    
    /// Dissmiss keyboard by clicking blank view of outside
    @IBAction func didTabViewForDismissKeyboard(_ sender: Any) {
        print("dismissKeyBoard")
        
        self.view.endEditing(true)
    }
    
    /// Click profile image view for selecting or changing profile image
    /// by using photo library
    @IBAction func didTabProfileImageView(_ sender: Any) {
        
        print("didTabProfileImageView")
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true    // 사진 앱에서, 이미지를 선택한 후 확대/축소 편집이 가능하도록
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - methods
    // MARK: - private

    /// Confirm password, they are same and not empty
    private func vaildatePassword(_ password: String?, _ confirmPwd: String?) -> Bool {
        
        if let pwd = password, let confirmPwd = confirmPwd, !pwd.isEmpty, !confirmPwd.isEmpty, pwd == confirmPwd {
            return true
        } else {
            return false
        }
    }
}

extension SignUpViewController: UITextFieldDelegate
{
    /// Dismiss keyboard if "Return" clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.image = image
        }
        
        // Dismiss image picker
        picker.dismiss(animated: true, completion: nil)
    }
}
