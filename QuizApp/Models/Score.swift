//
//  Score.swift
//  QuizApp
//
//  Created by five on 01/06/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

class Score{
    
    let username: String
    let points: Double
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
            
            let username = jsonDict["username"] as? String,
            let score = jsonDict["score"] as? String {
            
            
            self.username = username
            if let score = Double(score) {
                self.points = score
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
