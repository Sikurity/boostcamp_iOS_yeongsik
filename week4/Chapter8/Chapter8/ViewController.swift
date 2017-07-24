//
//  ViewController.swift
//  Chapter8
//
//  Created by YeongsikLee on 2017. 7. 21..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var currentQuestionLabel: UILabel!
    @IBOutlet var currentQuestionLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var nextQuestionLabel: UILabel!
    @IBOutlet var nextQuestionLabelCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var answerLabel: UILabel!
    
    var QnAs:[(question: String, answer: String)] = [
        ("What is the capital of south korea?", "Seoul"),
        ("Which method is used \nfor managing memory in iOS?", "Auto Reference Count")
    ]
    
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if currentQuestionIndex < QnAs.count {
            let question = QnAs[currentQuestionIndex].question
            currentQuestionLabel.text = question
        }
        
        answerLabel.text = "???"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        nextQuestionLabel.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// 다음 질문 버튼을 누르면 현재 질문을 오른쪽으로 날려보내고
    /// 다음 질문을 애니메이션을 적용해 왼쪽에서 끌어와 다음 질문으로 변경
    func animateQuestionLabelTransitions() {
        
        // Change alpha value
        // And Add a constraint about centerX
        let screenWidth = view.frame.width
        self.nextQuestionLabelCenterXConstraint.constant = 0
        self.currentQuestionLabelCenterXConstraint.constant += screenWidth
        
        UIView.animate (
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [.curveLinear],
            animations: {
                self.currentQuestionLabel.alpha = 0.0
                self.nextQuestionLabel.alpha = 1.0
                
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                // swap: 두 변수의 레퍼런스를 교환하는 함수
                swap(&self.currentQuestionLabel, &self.nextQuestionLabel)
                swap(&self.currentQuestionLabelCenterXConstraint, &self.nextQuestionLabelCenterXConstraint)
                
                self.updateOffScreenLabel()
            }
        )
    }
    
    /// 다음 질문 버튼을 누르면 답변을 담은 Label을 변경
    func animateAnswerLabelTransitions() {
        
        // Change alpha value
        // And Add a constraint about centerX
        UIView.animate (
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [.curveLinear],
            animations: {
                defer {
                    self.answerLabel.alpha = 0.2
                }
                
                print("hi2")
                guard self.currentQuestionIndex < self.QnAs.count else {
                    self.answerLabel.text = "???"
                    return
                }
                print("hi3")
                
                let answer = self.QnAs[self.currentQuestionIndex].answer
                self.answerLabel.text = answer
            },
            completion: { _ in
                self.answerLabel.alpha = 1.0
            }
        )
    }
    
    /// 다음 질문을 담은 Label을 화면 좌측으로 숨긴다
    func updateOffScreenLabel() {
        
        let screenWidth = view.frame.width
        nextQuestionLabelCenterXConstraint.constant = -screenWidth
    }
    
    @IBAction func showNextQuestion(_ sender: Any) {
        
        currentQuestionIndex += 1
        if currentQuestionIndex >= QnAs.count {
            currentQuestionIndex = 0
        }
        
        if currentQuestionIndex < QnAs.count {
            let question = QnAs[currentQuestionIndex].question
            nextQuestionLabel.text = question
        }
        
        answerLabel.text = "???"
        
        animateQuestionLabelTransitions()
    }
    
    @IBAction func showAnswerOfCurrentQuestion(_ sender: Any) {
        print("hi1")
        animateAnswerLabelTransitions()
    }
}
