//
//  BoostcampAPI
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 7. 31..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

enum MethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ContentType: String {
    case json = "application/json"
    case form = "multipart/form-data"
    case none
}

enum BoostcampAPIType {
    
    case selectAllArticles
    case loginWithEmail
    case signUpUser
    case createArticle
    case updateArticle(String)
    case removeArticle(String)
}

enum RequestResult {
    case success(Any)
    case failure(Error)
}

enum BoostcampAPIError: Error {
    case invalidJSONData
    case invalidRequest
    case invalidResponse
    case unknowned
}

protocol RestfulAPI {
    var uri: String {get set}
    var method: MethodType {get set}
    var content: ContentType {get set}
}

struct BoostcampAPI: RestfulAPI {
    
    static let baseURLString = "https://ios-api.boostcamp.connect.or.kr"
    static let dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    } ()
    
    var uri: String
    var method: MethodType
    var content: ContentType
    
    /// 부스트캠프 iOS 서버에서 제공하는 API 목록
    init(api: BoostcampAPIType){
        
        switch api {
        case .selectAllArticles:
            self.uri =  "/"
            self.method = .get
            self.content = .none
            
        case .loginWithEmail:
            self.uri =  "/login"
            self.method = .post
            self.content = .json
            
        case .signUpUser:
            self.uri =  "/user"
            self.method = .post
            self.content = .json
            
        case .createArticle:
            self.uri = "/image"
            self.method = .post
            self.content = .form
            
        case let .updateArticle(articleID):
            self.uri = "/image/\(articleID)"
            self.method = .put
            self.content = .form
            
        case let .removeArticle(articleID):
            self.uri = "/image/\(articleID)"
            self.method = .delete
            self.content = .none
        }
    }
    
    static func makeRequest(_ api: RestfulAPI, with data: Any?) -> URLRequest? {
        
        guard var components = URLComponents(string: baseURLString + api.uri) else {
            return nil
        }
        
        switch api.method {
        case .get, .delete:
            let parameters = data as? [String:String]
            components.queryItems = parameters?.map { return URLQueryItem(name: $0, value: $1) }
        default:
            break
        }
        
        guard let requestURL = components.url else {
            return nil
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = api.method.rawValue
        
        switch api.method {
        case .post, .put:
            request.httpBody = data as? Data
            switch api.content {
            case .json:
                request.setValue("\(api.content.rawValue)", forHTTPHeaderField: "Content-Type")
            case .form:
                request.setValue("\(api.content.rawValue); boundary=\(FileUploader.boundary)", forHTTPHeaderField: "Content-Type")
            default:
                break
            }
        default:
            break
        }
        
        return request
    }
}
