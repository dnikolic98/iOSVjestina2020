//
//  Quiz.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation

class Quiz{

    let id: Int
    let title: String
    let description: String
    let category: Category
    let level: Int
    let imageUrl: String
    let questions: [Question]

    init?(json: Any) {
        if let jsonDict = json as? [String: Any],

            let id = jsonDict["id"] as? Int,
            let title = jsonDict["title"] as? String,
            let description = jsonDict["description"] as? String,
            let category = jsonDict["category"] as? String,
            let level = jsonDict["level"] as? Int,
            let imageUrl = jsonDict["image"] as? String,
            let questionsJson = jsonDict["questions"] as? [Any]{

            self.id = id
            self.title = title
            self.description = description
            self.category = Category(rawValue: category.capitalized)!
            self.level = level
            self.imageUrl = imageUrl
            self.questions = questionsJson.compactMap(Question.init)
        } else {
            return nil
        }
    }
}
