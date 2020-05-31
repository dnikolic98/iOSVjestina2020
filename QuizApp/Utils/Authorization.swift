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
    static let ACCES_TOKEN = "accessToken"
    static let UID = "uid"
    static let USERNAME = "username"
    
    static func loginUser(authToken: AuthToken) {
        UserDefaults.standard.set(authToken.accessToken, forKey: ACCES_TOKEN)
        UserDefaults.standard.set(authToken.uid, forKey: UID)
        UserDefaults.standard.set(authToken.username, forKey: USERNAME)
    }
    
    static func logoutUser() {
        UserDefaults.standard.removeObject(forKey: ACCES_TOKEN)
        UserDefaults.standard.removeObject(forKey: UID)
        UserDefaults.standard.removeObject(forKey: USERNAME)
    }
    
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.string(forKey: ACCES_TOKEN) != nil
    }
    
    static func getUID() -> Int {
        return UserDefaults.standard.integer(forKey: UID)
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: USERNAME)
    }
    
    static func getAccesToken() -> String? {
        return UserDefaults.standard.string(forKey: ACCES_TOKEN)
    }
}
