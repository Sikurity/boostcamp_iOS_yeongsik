//
//  ViewController.swift
//  CustomUIView
//
//  Created by YeongsikLee on 2017. 7. 17..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var customButton: CustomUIView!
    @IBOutlet weak var toggleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        customButton.addTarget(self, action: #selector(testFunction), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeCustomBtnEnabled(_ sender: Any) {
        customButton.isEnabled = !customButton.isEnabled
        
        if customButton.isEnabled {
            toggleButton.setTitle("Disable The Button", for: .normal)
        } else {
            toggleButton.setTitle("Enable The Button", for: .normal)
        }
    }
    
    func testFunction() {
        print("testFunction")
    }
}

