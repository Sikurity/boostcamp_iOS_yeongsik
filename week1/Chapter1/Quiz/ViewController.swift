//
//  ViewController.swift
//  Quiz
//
//  Created by YeongsikLee on 2017. 7. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions:[String] = ["꼬냑의 재료는?", "7 곱하기 7은?", "버몬트 주의 주도는?"]
    let answers:[String] = ["포도", "49", "몬트필리어"]
    
    var currentQuestionIdx: Int = 0
    
    @IBAction func showNextQuestion(sender: AnyObject) {
        currentQuestionIdx += 1
        
        if currentQuestionIdx == questions.count {
            currentQuestionIdx = 0
        }
        
        let question: String = questions[currentQuestionIdx]
        questionLabel.text = question   /// 다음 질문으로 변경
        answerLabel.text = "???"        /// 정답 가리기
    }
    
    @IBAction func showAnswer(sender: AnyObject) {
        let answer: String = answers[currentQuestionIdx]
        answerLabel.text = answer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIdx]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
