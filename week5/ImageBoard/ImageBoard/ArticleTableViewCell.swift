//
//  ArticleTableViewCell.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet var articleImageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var imageTitle: UILabel!
    @IBOutlet var imageDesc: UILabel!
    @IBOutlet var imageDate: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var article: Article? {
        willSet(newValue) {
            guard let articleForCell = newValue else {
                
                articleImageView.image = nil
                spinner.startAnimating()
                
                imageTitle.text = "Waiting..."
                imageDesc.text = "From"
                imageDate.text = "Server"
                
                return
            }
            
            imageTitle.text = articleForCell.image_title
            imageDesc.text = articleForCell.image_desc
            imageDate.text = String(describing: Date(timeIntervalSince1970: TimeInterval(articleForCell.created_at)))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        article = nil
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        article = nil
    }
    
    func updateWithImage(image: UIImage?) {
        
        if let imageToDisplay = image {
            spinner.stopAnimating()
            articleImageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            articleImageView.image = nil
        }
    }
}
