//
//  ArticleStore.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum ImageError: Error {
    case createImageFail
    case invalidImageURL
}

class ArticleStore {
    
    private var articles: [Article] = []
    private var images: [String:UIImage] = [:]
    
    func overwrite(with newData: [Article]) {
        articles.removeAll()
        articles = newData
    }
    
    func append(_ article: Article) {
        articles.append(article)
    }
    
    func update(_ article: Article) {
        
        for (idx, _article) in articles.enumerated() {
            if article._id == _article._id {
                articles[idx] = article
                break
            }
        }
    }
    
    func delete(_ article: Article) {
        
        for (idx, _article) in articles.enumerated() {
            if article._id == _article._id {
                articles.remove(at: idx)
                break
            }
        }
    }
    
    func takeArticles() -> [Article] {
        
        return articles
    }
    
    /// 서버에서 최근 게시글 전부 불러오기
    func fetchRecentArticles(completion : @escaping (RequestResult) -> Void) {
        
        guard let request = BoostcampAPI.makeRequest(BoostcampAPI(api: .selectAllArticles), with: nil) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { jsonData, response, error in
    
            guard let data = jsonData, let httpStatus = response as? HTTPURLResponse else {
                print("Something Wrong In Networking")
                print("Error : \(error ?? BoostcampAPIError.unknowned)")
                
                return
            }
            
            guard httpStatus.statusCode == 200 else {
                print("StatusCode should be 200, but is \(httpStatus.statusCode)")
                print("Response = \(httpStatus)")
                
                return
            }
            
            let result = self.makeArticles(from: data)
            completion(result)
        }.resume()
    }
    
    /// 서버에 새 게시글 생성 요청
    func createArticle(with data: Data, completion: @escaping (RequestResult) -> Void) {
        
        guard let request = BoostcampAPI.makeRequest(BoostcampAPI(api: .createArticle), with: data) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { jsonData, response, error in
            
            guard let data = jsonData, let httpStatus = response as? HTTPURLResponse else {
                print("Something Wrong In Networking")
                print("Error : \(error ?? BoostcampAPIError.unknowned)")
                
                return
            }
            
            guard httpStatus.statusCode == 201 else {
                print("StatusCode should be 201, but is \(httpStatus.statusCode)")
                print("Response = \(httpStatus)")
                
                return
            }
            
            let result = self.makeArticles(from: data)
            completion(result)
        }.resume()
    }
    
    /// 서버에 게시글 수정 요청
    func updateArticle(for id: String, with data: Data, completion: @escaping (RequestResult) -> Void) {
        
        guard let request = BoostcampAPI.makeRequest(BoostcampAPI(api: .updateArticle(id)), with: data) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { jsonData, response, error in
            
            guard let data = jsonData, let httpStatus = response as? HTTPURLResponse else {
                print("Something Wrong In Networking")
                print("Error : \(error ?? BoostcampAPIError.unknowned)")
                
                return
            }
            
            guard httpStatus.statusCode == 201 else {
                print("StatusCode should be 201, but is \(httpStatus.statusCode)")
                print("Response = \(httpStatus)")
                
                return
            }
            
            let result = self.makeArticles(from: data)
            completion(result)
        }.resume()
    }
    
    /// 서버에 게시글 삭제 요청
    func deleteArticle(for id: String, with data: Data, completion: @escaping (RequestResult) -> Void) {
        
        guard let request = BoostcampAPI.makeRequest(BoostcampAPI(api: .removeArticle(id)), with: data) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { jsonData, response, error in
            
            guard let data = jsonData, let httpStatus = response as? HTTPURLResponse else {
                print("Something Wrong In Networking")
                print("Error : \(error ?? BoostcampAPIError.unknowned)")
                
                return
            }
            
            guard httpStatus.statusCode == 200 else {
                print("StatusCode should be 200, but is \(httpStatus.statusCode)")
                print("Response = \(httpStatus)")
                
                return
            }
            
            let result = self.extractArticle(from: data)
            completion(result)
        }.resume()
    }
    
    /// 서버에서 가져온 게시글의 이미지 URL로 이미지 요청
    func fetchImage(for article: Article, completion: @escaping (ImageResult) -> Void) {
        
        // image가 이미 Article에 존재하면 웹에서 다시 이미지를 불러오지 않도록한다
        if let image = images[article._id] {
            completion(.success(image))
            return
        }
        
        guard let imageURL = URL(string: BoostcampAPI.baseURLString + article.thumb_image_url) else {
            completion(.failure(ImageError.createImageFail))
            return
        }
        let request = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.images[article._id] = image
            }
            
            completion(result)
        }.resume()
    }
    
    /// 이미지 요청 처리
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard let imageData = data, let image = UIImage(data: imageData) else {
            return .failure( (data == nil) ? ImageError.createImageFail : ImageError.invalidImageURL )
        }
        
        return .success(image)
    }
    
    /// 최근 게시글 요청에 대한 응답 JSON 형식일 때, [Article]로 변환해 반환
    func makeArticles(from data: Data) -> RequestResult {
        
        do {
            let articles = try JSONDecoder().decode([Article].self, from: data)
            return .success(articles)
        } catch {
            return .failure(error)
        }
    }
    
    /// 게시글 변경에 대한 응답이 JSON 형식일 때, Article로 변환해 반환
    func extractArticle(from data: Data) -> RequestResult {
        
        do {
            let article = try JSONDecoder().decode(Article.self, from: data)
            return .success(article)
        } catch {
            return .failure(error)
        }
    }
}
