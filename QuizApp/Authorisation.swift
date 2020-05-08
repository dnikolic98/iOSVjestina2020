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
    
}
