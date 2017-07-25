//
//  GameViewController.swift
//  Game1to25
//
//  Created by YeongsikLee on 2017. 7. 25..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Private Variable
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private var timeGameStarted: Date?
    private var gameTimer: Timer?
    
    private var playtime: String {
        
        guard let started = timeGameStarted else {
            return "00:00:00"
        }
        
        var interval = Date().timeIntervalSince(started)
        
        // 잘못 눌러 받은 패널티 반영
        for stackView in buttonsGroupView.subviews {
            for view in stackView.subviews {
                if let gameButton = view.subviews[0] as? GameButton {
                    interval += Double(gameButton.countWrongPressed) * 1.5
                }
            }
        }
        
        let time = NSInteger(interval)
        
        let min = (time / 60) % 60
        let sec = time % 60
        let ms = Int(interval.truncatingRemainder(dividingBy: 1.0) * 100)
        
        return String(format: "%0.2d:%0.2d.%0.2d", min, sec, ms)
    }
    
    private var bestRecord: String {
        if appDelegate.history.count > 0 {
            
            let name = appDelegate.history[0].name
            let date = appDelegate.history[0].playtime
            
            return name + " " + date
        } else {
            
            return "- --:--:--"
        }
    }
    
    
    // MARK: - Private Variable
    
    @IBOutlet var buttonsGroupView: UIStackView!
    @IBOutlet var gameStartButton: UIButton!
    @IBOutlet var recordTimeLabel: UILabel!
    @IBOutlet var bestRecordLabel: UILabel!
    
    // MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameTimer = nil
        timeGameStarted = nil
        
        buttonsGroupView.isHidden = true
        gameStartButton.isHidden = false
        
        bestRecordLabel.text = bestRecord
    }
    
    // MARK: - Actions
    
    @IBAction func didHomeButtonTapped(_ sender: Any) {
        
        if( isModal ) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func GameStart(_ sender: Any) {
        
        GameButton.initGameButtons()
        
        gameStartButton.isHidden = true
        buttonsGroupView.isHidden = false
        
        for stackView in buttonsGroupView.subviews {
            for view in stackView.subviews {
                if let gameButton = view.subviews[0] as? GameButton{
                    gameButton.setup()
                }
            }
        }
        
        startTimer()
    }
    
    
    // MARK: - Timer
    
    private func startTimer() {
        
        timeGameStarted = Date()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc private func update() {
        
        recordTimeLabel.text = playtime
        
        if( GameButton.isAllPressed )
        {
            let alertController = UIAlertController(title: "Clear!", message: "Enter Yout Name", preferredStyle: .alert)
            
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Name"
            })
            
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                
                if let name = alertController.textFields?[0].text {
                    
                    self.appDelegate.history.append(Record(name: name, playtime: self.playtime, date: Date()))
                    self.appDelegate.history.sort(by: {$0.0.playtime < $0.1.playtime })
                    
                    self.bestRecordLabel.text = self.bestRecord
                    
                    self.appDelegate.save()
                }
            })
            alertController.addAction(confirmAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                print("Canelled")
            })
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: { _ in })
            
            endTimer()
        }
    }
    
    private func endTimer() {
        gameTimer?.invalidate()
        
        gameTimer = nil
        timeGameStarted = nil
        
        buttonsGroupView.isHidden = true
        gameStartButton.isHidden = false
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
