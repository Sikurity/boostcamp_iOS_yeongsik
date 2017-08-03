//
//  MainTabBarController.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 1..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.articleStore.fetchRecentArticles { requestResult in
            
            /// 서버의 json 응답을 [Article]로 변환해 저장
            if case let .success(result) = requestResult {
                
                guard let articles = result as? [Article] else {
                    return
                }
                
                self.appDelegate.articleStore.overwrite(with: articles)
                
                guard
                    let vcs = self.viewControllers, vcs.count >= 2,
                    let nc1 = vcs[0] as? UINavigationController,
                    let tvc = nc1.viewControllers.first as? ImagesTableViewController,
                    let nc2 = vcs[1] as? UINavigationController,
                    let cvc = nc2.viewControllers.first as? ImagesCollectionViewController
                else {
                    print("Somebody Help Me...")
                    
                    return
                }
                
                DispatchQueue.main.async {
                    tvc.articles = articles
                    cvc.articles = articles
                    
                    tvc.tableView.reloadData()
                    cvc.collectionView?.reloadData()
                }
            } else if case let .failure(error) = requestResult {
                print("Get Articles From Server Failed... \(error)")
            }
        }
        
        // Do any additional setup after loading the view.
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

