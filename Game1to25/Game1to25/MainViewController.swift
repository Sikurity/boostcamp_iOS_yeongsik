//
//  ViewController.swift
//  Game1to25
//
//  Created by YeongsikLee on 2017. 7. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var gameTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // animation with damping
        animateGameTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// GameTitle Animation
    func animateGameTitle() {
        
        UIView.animate (
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [.repeat, .autoreverse],
            animations: {
                
                self.gameTitleLabel.transform = CGAffineTransform(scaleX: 2, y: 2)
            },
            completion: { _ in 
                
                self.gameTitleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        )
    }
}

extension UIViewController {
    
    /// modal 
    var isModal: Bool {
        
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
}
