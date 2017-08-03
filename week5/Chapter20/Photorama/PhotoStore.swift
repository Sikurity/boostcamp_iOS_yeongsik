//
//  PhotoStore.swift
//  Chapter19
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

class PhotoStore {
    
    let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    /// 앱 실행 후, 서버로부터 최근 이미지들을 다수 가져오기
    func fetchRecentPhotos(completion : @escaping (PhotosResult) -> Void) {
        
        guard let url = FlickrAPI.recentPhotosURL() else {
            return
        }
        
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { [unowned self] (data, response, error) -> Void in
            
            let result = self.processRecentPhotosRequest(from: data, error: error)
            
            print("Request Header")
            // 동메달 과제: 응답 정보 출력하기
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("Header Fields")
                
                for field in httpResponse.allHeaderFields.keys {
                    print("\(field)")
                }
            }
            
            completion(result)
        }.resume()
    }
    
    /// 앱 실행 후, 서버로부터 받아온 다수의 최근 이미지들 처리
    func processRecentPhotosRequest(from data: Data?, error: Error?) -> PhotosResult {
        
        guard let jsonData = data else {
            return .failure(error ?? NSError())
        }
        
        return FlickrAPI.makePhotos(from: jsonData)
    }
    
    /// 이미지 가져오기
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        // image가 이미 Photo에 존재하면 웹에서 다시 이미지를 불러오지 않도록한다
        if let image = photo.image {
            completion(.success(image))
            return
        }
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            print("Request Header")
            // 동메달 과제: 응답 정보 출력하기
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                print("Header Fields")
                
                for field in httpResponse.allHeaderFields.keys {
                    print("\(field)")
                }
            }
            
            let result = self.makeImage(from: data, error: error)
            if case let .success(image) = result {
                photo.image = image
            }
            
            completion(result)
        }.resume()
    }
    
    //
    func makeImage(from data: Data?, error: Error?) -> ImageResult {
        
        guard let imageData = data, let image = UIImage(data: imageData) else {
            
            // 이미지를 만들 수 없다
            if data == nil {
                return .failure(error ?? NSError())
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        
        return .success(image)
    }
}
