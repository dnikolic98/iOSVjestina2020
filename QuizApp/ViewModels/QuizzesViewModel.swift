//
//  QuizzesViewModel.swift
//  QuizApp
//
//  Created by five on 09/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation


struct QuizCellModel {
    
    let id: Int
    let title: String
    let description: String
    let category: Category
    let level: Int
    let imageUrl: URL?
    let questions: [Question]
    
    init(quiz: Quiz) {
        self.id = quiz.id
        self.title = quiz.title
        self.description = quiz.description
        self.category = quiz.category
        self.level = quiz.level
        self.imageUrl = URL(string: quiz.imageUrl)
        self.questions = quiz.questions
    }
}

class QuizzesViewModel {
    private var quizzes: [Quiz]?
    
    func fetchQuizzes(completion: @escaping (([Quiz]?) -> Void))  {
        QuizzesService().fetchQuizzes() { (quizzes) in
            if let quizzes = quizzes{
                self.quizzes = quizzes
                completion(quizzes)
            } else {
                completion(nil)
            }
        }
    }
    
    func quiz(indexPath: IndexPath) -> QuizCellModel? {
        let category = Category.allCases[indexPath.section]
        guard let quizzes = quizzesInCategory(category: category) else {
            return nil
        }
        return QuizCellModel(quiz: quizzes[indexPath.row])
    }
    
    func getQuiz(indexPath: IndexPath) -> Quiz? {
        guard let quizzes = quizzes else { return nil }
        return quizzes[indexPath.row]
    }
    
    func numberOfQuizzes() -> Int {
        return quizzes?.count ?? 0
    }
    
    func numberOfQuizzesInCategory(category: Category) -> Int {
        return quizzesInCategory(category: category)?.count ?? 0
    }
    
    func getFunFact(forWord word: String) -> String? {
        guard let quizzes = quizzes else { return nil }
        var questions = [String]()
        
        for quiz in quizzes {
            questions.append(contentsOf: quiz.questions.compactMap{$0.question}.filter{$0.contains(word)})
        }
        
        let fact = "There are \(questions.count) questions that contain the word \"\(word)\""
        return fact
    }
    
    public func quizzesInCategory(category: Category) -> [Quiz]? {
        return quizzes?.filter{$0.category == category}
    }
}
