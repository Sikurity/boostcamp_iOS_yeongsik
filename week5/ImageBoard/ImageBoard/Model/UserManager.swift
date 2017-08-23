//
//  UserManager.swift
//  ImageBoard
//
//  Created by YeongsikLee on 2017. 8. 2..
//  Copyright © 2017년 boostcamp. All rights reserved.
//

import UIKit

class UserManager {
    
    private var loggedInUser: User?
    
    /// 서버에서 최근 게시글 전부 불러오기
    func login(json: Data?, completion : @escaping ([String: Any?]) -> Void) {
        
        guard let request = BoostcampAPI.makeRequest(BoostcampAPI(api: .loginWithEmail), with: json) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { jsonData, response, error in
            
            let httpError = error ?? BoostcampAPIError.unknowned
            guard let data = jsonData, let httpResponse = response as? HTTPURLResponse else {
                
                print("Something Wrong In Networking")
                print("Error : \(httpError)")
                
                completion(["code": -1, "message": "Network error", "error": httpError])
                
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                
                print("StatusCode should be 200, but is \(httpResponse.statusCode)")
                print("Response = \(httpResponse)")
                
                completion(["code": httpResponse.statusCode, "message": "Unauthorzed", "error": httpError])
                
                return
            }
            
            /// 서버의 json 응답을 [Article]로 변환해 저장
            let result = self.extractUserInfo(from: data)
            if case let .success(user) = result {
                
                guard let loginUser = user as? User else {
                    completion(["code": httpResponse.statusCode, "message": "Somethine Wrong...", "error": BoostcampAPIError.unknowned])
                    return
                }
                
                self.loggedInUser = loginUser
                completion(["code": httpResponse.statusCode, "message": nil, "error": nil])
                
            } else if case let .failure(error) = result {
                completion(["code": httpResponse.statusCode, "message": "Boostcamp API Error", "error": error])
            }
        }.resume()
    }
    
    /// 서버에서 최근 게시글 전부 불러오기
    func signUp(json: Data?, completion : @escaping ([String: Any?]) -> Void) {
        
        guard let request = BoostcampAPI.makeRequest(BoostcampAPI(api: .signUpUser), with: json) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { jsonData, response, error in
            
            let httpError = error ?? BoostcampAPIError.unknowned
            
            guard let data = jsonData, let httpResponse = response as? HTTPURLResponse else {
                
                print("Something Wrong In Networking")
                print("Error : \(httpError)")
                
                completion(["code": -1, "message": "Network error", "error": httpError])
                
                return
            }
            
            guard httpResponse.statusCode == 201 else {
                print("StatusCode should be 200, but is \(httpResponse.statusCode)")
                print("Response = \(httpResponse)")
                
                completion(["code": httpResponse.statusCode, "message": "Email Overlapped!!", "error": nil])
                
                return
            }
            
            completion(["code": httpResponse.statusCode, "message": "Success!!", "error": nil])
        }.resume()
    }
    
    /// 로그인, 회원가입 요청에 대한  JSON 형식일 때, User 객체로 변환해 반환
    func extractUserInfo(from data: Data) -> RequestResult {
        
        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            return .success(user)
        } catch {
            return .failure(error)
        }
    }
    
    func isOwnedByLoggedInUser(_ article: Article) -> Bool {
        
        return loggedInUser?._id == article.author
    }
}
