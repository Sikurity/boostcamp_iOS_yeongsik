//
//  CRUDImageViewController.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 1..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

enum CRUDMode {
    case create
    case read(Bool)
    case update
    case delete
}

class CRUDImageViewController: UIViewController {
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var removeButton: UIBarButtonItem!

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet var imageRecognizer: UITapGestureRecognizer!
    
    @IBOutlet var imageTitleTextField: UITextField!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var imageDescTextView: UITextView!
    @IBOutlet var createdDateLabel: UILabel!
    @IBOutlet var articleImageView: UIImageView!
    
    var article: Article!
    var path: String?      /// 이미지 업로드를 위한 변수
    
    var currentMode: CRUDMode! {
        willSet(newValue) {
            
            guard let mode = newValue else {
                return
            }
            
            switch mode {
            case .create, .update:
                imageTitleTextField.isEnabled = true
                self.navigationItem.setHidesBackButton(true, animated: false)
                self.navigationItem.leftBarButtonItems = [cancelButton]
                self.navigationItem.rightBarButtonItems = [doneButton]
            case let .read(isOwned):
                print(isOwned)
                self.navigationItem.rightBarButtonItems = isOwned ? [removeButton, editButton] : nil
                self.navigationItem.leftBarButtonItems = nil
                self.navigationItem.setHidesBackButton(false, animated: false)
                imageTitleTextField.isEnabled = false
                
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageTitleTextField.delegate = self
        
        tapRecognizer.cancelsTouchesInView = false
        imageRecognizer.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let mode = currentMode else {
            return
        }
        
        if case .create = mode {
            nicknameLabel.text = nil
            createdDateLabel.text = nil
            
            return
        }
        
        imageTitleTextField.text = article.image_title
        nicknameLabel.text = article.author_nickname
        imageDescTextView.text = article.image_desc
        
        let dateString = String(describing: Date(timeIntervalSince1970: TimeInterval(article.created_at)))
        createdDateLabel.text = dateString
        
        appDelegate.articleStore.fetchImage(for: article){ (result) in
            
            if case let .success(fetchedImage) = result {
                self.articleImageView.image = fetchedImage
            } else if case let .failure(error) = result {
                print("Fetch Image From Server Failed... \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Dissmiss keyboard by clicking blank view of outside
    @IBAction func didTapViewForDismissKeyboard(_ sender: Any) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func editArticle(_ sender: Any) {
        currentMode = .update
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        guard let mode = currentMode else {
            return
        }
        
        if case .update = mode {
            currentMode = .read(appDelegate.userManager.isOwnedByLoggedInUser(article))
        } else if( isModal ) {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func done(_ sender: Any) {
        
        guard let mode = currentMode else {
            return
        }
        
        switch mode {
        case .create:
            
            guard
                let image = articleImageView.image,
                let data = UIImageJPEGRepresentation(image, 0.70)
            else {
                return
            }
            
            let imageTitle = imageTitleTextField.text ?? "Untitled"
            let imageDesc = imageDescTextView.text ?? ""
            
            let params = ["image_title": imageTitle, "image_desc": imageDesc]
            let body = FileUploader.createBody(with: params, filePathKey: "file", filename: imageTitle + ".jpg", loaded: data)
            appDelegate.articleStore.createArticle(with: body) { requestResult in
                
                if case let .success(result) = requestResult {
                    guard let article = result as? Article else {
                        print("Request result cannot convert to article")
                        // 테이블 뷰 업데이트
                        // 콜렉션 뷰 업데이트
                        return
                    }
                    
                    self.appDelegate.articleStore.append(article)
                } else if case let .failure(error) = requestResult {
                    print("Create Article Failed... \(error)")
                }
            }
        case .update:
            guard
                let image = articleImageView.image,
                let data = UIImageJPEGRepresentation(image, 0.75)
            else {
                return
            }
            
            let imageTitle = imageTitleTextField.text ?? "Untitled"
            let imageDesc = imageDescTextView.text ?? ""
            
            let params = ["image_title": imageTitle, "image_desc": imageDesc]
            let body = FileUploader.createBody(with: params, filePathKey: "file", filename: imageTitle + ".jpg", loaded: data)
            appDelegate.articleStore.updateArticle(for: article._id, with: body) { requestResult in
                
                if case let .success(result) = requestResult {
                    guard let article = result as? Article else {
                        print("Request result cannot convert to article")
                        // 테이블 뷰 업데이트
                        // 콜렉션 뷰 업데이트
                        return
                    }
                    
                    self.appDelegate.articleStore.update(article)
                } else if case let .failure(error) = requestResult {
                    print("Create Article Failed... \(error)")
                }
            }
            
        default:
            break
        }
    }
    
    @IBAction func deleteArticle(_ sender: Any) {
        
        appDelegate.articleStore.deleteArticle(for: article._id) { requestResult in
            
            if case let .success(result) = requestResult {
                guard let article = result as? Article else {
                    print("Request result cannot convert to article")
                    // 테이블 뷰 업데이트
                    // 콜렉션 뷰 업데이트
                    return
                }
                
                self.appDelegate.articleStore.delete(article)
            } else if case let .failure(error) = requestResult {
                print("Create Article Failed... \(error)")
            }
        }
    }
    
    @IBAction func didImageTapped(_ sender: Any) {
        
        guard let mode = currentMode, case .create = mode else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true    // 사진 앱에서, 이미지를 선택한 후 확대/축소 편집이 가능하도록
        
        self.present(imagePicker, animated: true, completion: nil)
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

extension CRUDImageViewController: UITextFieldDelegate
{
    /// Dismiss keyboard if "Return" clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension CRUDImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        defer {
            // Dismiss image picker
            picker.dismiss(animated: true, completion: nil)
        }
        
        guard
            let image = info[UIImagePickerControllerEditedImage] as? UIImage,
            let url = info[UIImagePickerControllerReferenceURL] as? URL
        else {
            return
        }
        
        self.articleImageView.image = image
        self.path = url.path
    }
}
