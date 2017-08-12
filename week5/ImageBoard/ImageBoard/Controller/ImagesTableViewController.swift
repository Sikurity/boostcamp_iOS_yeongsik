//
//  ImagesTableViewController.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 1..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ImagesTableViewController: UITableViewController {

    var articles:[Article]? // Articles Initialized By MainTabBarController...
    var isFiltered: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: Any) {
        
        appDelegate.articleStore.fetchRecentArticles { requestResult in
            
            DispatchQueue.main.async {
                defer {
                    self.refreshControl?.endRefreshing()
                }
                
                if case let .success(result) = requestResult {
                    
                    guard let articles = result as? [Article] else {
                        print("Cannot convert request result to [Article]")
                        return
                    }
                    
                    self.articles = articles
                    self.tableView.reloadData()
                } else if case let .failure(error) = requestResult {
                    print("Something Wrong... \(error)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func filterArticles(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.isFiltered = !(self.isFiltered ?? false)
            
            if self.isFiltered == true {
                self.articles = self.articles?.filter{ self.appDelegate.userManager.isOwnedByLoggedInUser($0) }
            } else {
                self.articles = self.appDelegate.articleStore.takeArticles()
            }
            
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableCell", for: indexPath)
        guard let customCell = cell as? ArticleTableViewCell else {

            return cell
        }

        return customCell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let article = articles?[indexPath.row] else {
            return
        }
        
        // 이미지 데이터를 내려받는다, 오래걸리므로 비동기
        appDelegate.articleStore.fetchImage(for: article){ (result) in
            
            if case let .success(fetchedImage) = result {
                
                DispatchQueue.main.async {
                    
                    guard let articleIndex = self.articles?.index(of: article) else {
                        return
                    }
                    
                    let indexPath = IndexPath(row: articleIndex, section: 0)
                    
                    // 요청이 완료될 때 화면에 보이는 셀만 업데이트한다
                    if let cell = self.tableView.cellForRow(at: indexPath) as? ArticleTableViewCell {
                        cell.article = self.articles?[indexPath.row]
                        cell.updateWithImage(image: fetchedImage)
                    }
                }
            } else if case let .failure(error) = result {
                
                print("Image Fetch Failed... \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.frame.height / 8
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "createArticleSegue" {
            
            guard
                let tnc = segue.destination as? TabNavigationController,
                let crudVC = tnc.viewControllers.first as? CRUDImageViewController
            else {
                return
            }
            
            crudVC.currentMode = .create
        }
        else if segue.identifier == "readArticleSegue" {
            
            guard
                let crudVC = segue.destination as? CRUDImageViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let article = articles?[indexPath.row]
            else {
                return
            }
            
            crudVC.article = article
            crudVC.currentMode = .read(appDelegate.userManager.isOwnedByLoggedInUser(article))
        }
    }
    
}
