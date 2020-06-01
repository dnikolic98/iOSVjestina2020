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
    private let resultUrl = "https://iosquiz.herokuapp.com/api/result"
    private let leaderboardUrl = "https://iosquiz.herokuapp.com/api/score?quiz_id="
    
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
    
    
    func fetchLeaderboard(forQuiz id: Int, completion: @escaping (([Score]?) -> Void)) {
        if let url = URL(string: leaderboardUrl + "\(id)") {
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let accessToken = Authorization.getAccesToken() {
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
            request.httpMethod = "GET"
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [Any] {
                            let scores = jsonDict.compactMap(Score.init)
                            completion(scores)
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
    
    func postResult(quizId: Int,  numberOfCorrect: Int, time: Double, completion: @escaping ((HttpStatusCode?) -> Void)) {
        if let url = URL(string: resultUrl) {
            var request = URLRequest(url: url)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if let accessToken = Authorization.getAccesToken(){
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            }
            request.httpMethod = "POST"
            
            let parameters: [String: Any] = [
                "quiz_id": quizId,
                "user_id": Authorization.getUID(),
                "time": time,
                "no_of_correct": numberOfCorrect
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse {
                    let httpStatusCode = HttpStatusCode(rawValue: httpResponse.statusCode)
                    completion(httpStatusCode)
                }
            }
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
}
