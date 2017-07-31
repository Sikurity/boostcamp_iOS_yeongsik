//
//  ChangeDateViewController.swift
//  Chapter13
//
//  Created by YeongsikLee on 2017. 7. 24..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

/// 금메달 과제: 더 많은 뷰 컨트롤러 푸시하기
class ChangeDateViewController: UIViewController {
    
    @IBOutlet var itemDatePicker: UIDatePicker!

    var item: Item!
    
    /// 날짜가 바뀌면 바로 아이템에 반영
    @IBAction func didDateValueChanged(_ datePicker: UIDatePicker) {
        item.dateCreated = datePicker.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemDatePicker.date = item.dateCreated
        itemDatePicker.maximumDate = Date()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
