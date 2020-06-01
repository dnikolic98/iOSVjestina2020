//
//  LeaderboardViewModel.swift
//  QuizApp
//
//  Created by five on 31/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation

struct LeaderboardCellModel {
    
    let position: Int
    let username: String
    let points: Double
    
    init(position: Int, score: Score) {
        self.position = position
        self.username = score.username
        self.points = score.points
    }
}

class LeaderboardViewModel {
    
    private var quizId: Int
    private var scores: [Score]?
    
    init(quizId: Int) {
        self.quizId = quizId
    }
    
    public func fetchScores(completion: @escaping (([Score]?) -> Void)) {
        QuizzesService().fetchLeaderboard(forQuiz: quizId, completion: {(scores) in
            if let scores = scores {
                self.scores = scores
                self.scores?.sort{ $0.points > $1.points }
                let top20 = self.scores?[0..<20]
                self.scores = Array(top20!)
                completion(scores)
            } else {
                completion(nil)
            }
        })
    }
    
    public func numberOfScores() -> Int {
        return scores?.count ?? 0
    }
    
    public func getScore(indexPath: IndexPath) -> LeaderboardCellModel? {
        guard let scores = scores else { return nil }
        return LeaderboardCellModel(position: indexPath.row + 1, score: scores[indexPath.row])
    }
    
}
