//
//  FlickrAPI
//  Chapter19
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import Foundation

enum Method: String {
    
    case recentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

enum FlickrError: Error {
    case invaildJSONData
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL? {
        
        guard var componets = URLComponents(string: baseURLString) else {
            return nil
        }
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey,
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        componets.queryItems = queryItems
        
        return componets.url
    }
    
    static func recentPhotosURL() -> URL? {
        
        return flickrURL(method: .recentPhotos, parameters: ["extras": "url_h, date_taken"])
    }
    
    static func makePhoto(from jsonObject: [String: AnyObject]) -> Photo? {
        
        guard let photoID = jsonObject["id"] as? String,
            let title = jsonObject["title"] as? String,
            let photoURLString = jsonObject["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateString = jsonObject["datetaken"] as? String,
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        
        return Photo(photoID: photoID, title: title, remoteURL: url, dateTaken: dateTaken)
    }
    
    static func makePhotos(from jsonData: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            guard let jsonDictionary = jsonObject as? [String:AnyObject],
                let photos = jsonDictionary["photos"] as? [String:AnyObject],
                let photosArray = photos["photo"] as? [[String:AnyObject]] else {
                    
                // 의도한 JSON 구조체와 맞지 않음
                return .failure(FlickrError.invaildJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = makePhoto(from: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            // photos에서 아무것도 파싱할 수 없음
            if finalPhotos.count == 0 && photosArray.count > 0 {
                return .failure(FlickrError.invaildJSONData)    // JSON 포맷 확인 요망
            }
            
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
}
