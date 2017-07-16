//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by YeongsikLee on 2017. 7. 10..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit
import WebKit

// 동메달 과제 : 추가 탭
class WebViewController: UIViewController {
    var webView: WKWebView!
    var urlAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 웹 뷰 생성
        webView = WKWebView()
        
        // 지도 뷰를 뷰 컨트롤러의 view로 설정
        self.view = webView
        
        urlAddress = "https://www.bignerdranch.com"
        webView.load(URLRequest(url: URL(string: urlAddress)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
