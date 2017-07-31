//
//  PhotosViewController.swift
//  Chapter19
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

/// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = photoDataSource
            collectionView.delegate = self
            
            /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(pageUp))
            swipeUp.direction = .up
            collectionView.addGestureRecognizer(swipeUp)
            
            /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(pageDown))
            swipeDown.direction = .down
            collectionView.addGestureRecognizer(swipeDown)
        }
    }
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos {
            (photosResult) -> Void in
            
            DispatchQueue.main.async {
                switch photosResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                
                self.collectionView.reloadSections(IndexSet.init(integer: 0))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Paging Helpers
    /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
    @objc func pageUp() {
        print("Page UP!!!")
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        var lastPath = IndexPath(row: 0, section: 0)
        for index in indexPaths {
            if index.row > lastPath.row { lastPath = index }
        }
        
        lastPath = IndexPath(row: lastPath.row + 1, section: lastPath.section)
        if lastPath.row < (photoDataSource.photos.count - 1) {
            
            collectionView.scrollToItem(at: lastPath, at: .top, animated: false)
            UIView.transition(
                with: collectionView,
                duration: 0.5,
                options: [.transitionCurlUp, .curveEaseIn],
                animations: { self.view.layoutIfNeeded() },
                completion: nil
            )
        }
    }
    
    /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
    @objc func pageDown() {
        print("Page Down!!!")
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        var firstPath = IndexPath(row: photoDataSource.photos.count, section: 0)
        for index in indexPaths {
            if index.row < firstPath.row { firstPath = index }
        }
        
        if firstPath.row > 0 {
            firstPath = IndexPath(row: firstPath.row - 1, section: firstPath.section)
            
            collectionView.scrollToItem(at: firstPath, at: .bottom, animated: false)
            UIView.transition(
                with: collectionView,
                duration: 0.5,
                options: [.transitionCurlDown, .curveEaseIn],
                animations: {self.view.layoutIfNeeded()},
                completion: nil
            )
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPhoto" {
            guard let selected = collectionView.indexPathsForSelectedItems?.first else {
                return
            }
            
            let photo = photoDataSource.photos[selected.row]
            
            let photoInfoVC = segue.destination as! PhotoInfoViewController // 변환 안된다면 오류와 함께 종료될 필요 있음
            
            photoInfoVC.photo = photo
            photoInfoVC.store = store
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        // 이미지 데이터를 내려받는다, 오래걸리므로 비동기
        store.fetchImage(for: photo){ (result) in
            
            DispatchQueue.main.async {
                
                // 사진의 IndexPath는 요청의 시작과 끝 사이에 변경될 수 있다
                // 따라서, 가장 최근 IndexPath를 찾는다
                
                guard let photoIndex = self.photoDataSource.photos.index(of: photo) else {
                    return
                }
                
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                
                // 요청이 완료될 때 화면에 보이는 셀만 업데이트한다
                if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(image: photo.image)
                }
            }
        }
    }
    
    /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 50.0, height: 50.0)
        }
        
        let width = itemWidth(flow)
        let height = itemHeight(flow)
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Sizing Helper Functions
    /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
    private func itemWidth(_ layout: UICollectionViewFlowLayout) -> CGFloat {
        
        let width = collectionView.bounds.width
        return ( width - (layout.sectionInset.left * 2 + layout.minimumInteritemSpacing * 3) ) / 4
    }
    
    /// 금메달 과제 - 커스텀 레이아웃 만들기 : 너무 어려워서 정답을 보고, 이해하는 식으로 수행하였습니다.
    private func itemHeight(_ layout: UICollectionViewFlowLayout) -> CGFloat {
        
        let minHeight = itemWidth(layout)
        let itemSpace = (collectionView.bounds.height - (layout.sectionInset.top + layout.sectionInset.bottom))
        let numRows = Int(itemSpace / (minHeight + layout.minimumInteritemSpacing))
        
        let adjustedHeight: CGFloat = {
            if numRows == 1 { // force minimum of 2 rows
                return (itemSpace - layout.minimumInteritemSpacing * 2) / 2
            } else {
                return (itemSpace - (layout.minimumInteritemSpacing * CGFloat(numRows))) / CGFloat(numRows)
            }
        }()
        
        return adjustedHeight
    }
}
