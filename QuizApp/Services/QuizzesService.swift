//
//  QuizService.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//


import Foundation

class QuizzesService {
    private let quizzesUrl = "https://iosquiz.herokuapp.com/api/quizzes"
    
    func fetchQuizzes(completion: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: quizzesUrl) {
                let request = URLRequest(url: url)
                
                let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let data = data {
                        
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if let jsonDict = json as? [String: Any],
                                let quizzesList = jsonDict["quizzes"] as? [Any] {
                                let quizzes = quizzesList.compactMap(Quiz.init)
                                completion(quizzes)
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
