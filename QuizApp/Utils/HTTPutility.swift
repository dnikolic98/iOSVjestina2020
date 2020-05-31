//
//  HTTPutility.swift
//  QuizApp
//
//  Created by five on 31/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.

enum HttpStatusCode: Int {
    case UNAUTHORIZED = 401
    case FORBIDDEN = 403
    case NOT_FOUND = 404
    case BAD_REQUEST = 400
    case OK = 200
    
    var message: String {
        switch self {
        case .UNAUTHORIZED:
            return "Invalid access token"
        case .FORBIDDEN:
            return "Access token does not match user ID"
        case .NOT_FOUND:
            return "Quiz ID does not exist"
        case .BAD_REQUEST:
            return "An error occurred"
        case .OK:
            return "Success"
        }
    }
}
