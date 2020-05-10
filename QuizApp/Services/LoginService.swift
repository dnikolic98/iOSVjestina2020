//
//  LoginService.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation

class LoginService {
    
    private let loginUrl = "https://iosquiz.herokuapp.com/api/session"
    
    func login(username: String, password: String, completion: @escaping ((AuthToken?) -> Void)) {
        if let url = URL(string: loginUrl) {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let parameters = ["username": username, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any],
                            let accessToken = jsonDict["token"] as? String,
                            let uid = jsonDict["user_id"] as? Int {
                            
                            let authToken = AuthToken(accessToken: accessToken, uid: uid, username: username)
                            completion(authToken)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
}
