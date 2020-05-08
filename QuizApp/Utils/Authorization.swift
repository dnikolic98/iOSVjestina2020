//
//  Authorization.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation

struct AuthToken {
    let accessToken: String
    let uid: Int
    let username: String
    
    init(accessToken: String, uid: Int, username: String) {
        self.accessToken = accessToken
        self.uid = uid
        self.username = username
    }
}

class Authorization {
    static func loginUser(authToken: AuthToken) {
        UserDefaults.standard.set(authToken.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(authToken.uid, forKey: "uid")
        UserDefaults.standard.set(authToken.username, forKey: "username")
    }
    
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "uid")
        UserDefaults.standard.removeObject(forKey: "username")
    }
    
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: "accessToken") != nil
    }
}
