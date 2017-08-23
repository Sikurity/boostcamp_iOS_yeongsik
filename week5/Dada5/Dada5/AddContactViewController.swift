//
//  AddContactViewController.swift
//  Dada5
//
//  Created by YeongsikLee on 2017. 8. 3..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    
    var contact: Contact? {
        guard
            let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let phoneNumber = phoneNumberTextField.text
        else {
            return nil
        }
        
        return Contact(firstName, lastName, phoneNumber)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
