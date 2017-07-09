//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by YeongsikLee on 2017. 7. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- properties
    //MARK: IBOutlets
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    //MARK:- properties
    //MARK: let
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    
    //MARK:- properties
    //MARK: var
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5 / 9)
        } else {
            return nil
        }
    }
    
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    
    //MARK:- methods
    //MARK: IBActions
    @IBAction func dissmissKeyboard(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textfield: UITextField) {
        
        if let text = textfield.text, let value = Double(text) {
            celsiusLabel.text = "\(value)";
        } else {
            celsiusLabel.text = "???";
        }
    }
    
    //MARK:- methods
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- delegate methods
    //MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Current text: \(String(describing: textField.text))")
        print("Replacement text: \(string)")
        
        return true
    }
    
    //MARK:- private methods
    //MARK: custom
    private func updateCelsiusLabel() {
        
        if let value = celsiusValue {
            celsiusLabel.text = "\(value)";
        } else {
            celsiusLabel.text = "???";
        }
    }
}
