//
//  ImagesCollectionViewController.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 1..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController {
    
    var articles:[Article]? // Articles Initialized By MainTabBarController...
    var isFiltered: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            self.collectionView?.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionCell", for: indexPath)
        guard let customCell = cell as? ArticleCollectionViewCell else {

            return cell
        }

        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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
                    if let cell = self.collectionView?.cellForItem(at: indexPath) as? ArticleCollectionViewCell {
                        cell.article = article
                        cell.updateWithImage(image: fetchedImage)
                    }
                }
            } else if case let .failure(error) = result {
                
                print("Image Fetch Failed... \(error)")
            }
        }
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
                let indexPath = collectionView?.indexPathsForSelectedItems?.first,
                let article = articles?[indexPath.row]
                else {
                    return
            }
            
            crudVC.article = article
            crudVC.currentMode = .read(appDelegate.userManager.isOwnedByLoggedInUser(article))
        }
    }
}
