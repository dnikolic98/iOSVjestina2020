//
//  QuizImageService.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation
import UIKit

class QuizImageService {
    func fetchImage(quiz: QuizCellModel, completion: @escaping ((UIImage?) -> Void)){
        let urlString = quiz.imageUrl
        if let url = urlString {
            let request = URLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
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
