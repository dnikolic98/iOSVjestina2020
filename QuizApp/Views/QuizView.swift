//
//  QuizView.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit
import Kingfisher

protocol QuizStartDelegate {
    func didStartQuiz()
}

class QuizView: UIView {
    var quizStartDelegate: QuizStartDelegate!
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var quizImageView: UIImageView!
    @IBOutlet private weak var startButton: UIButton!
    
    @IBAction private func startQuizPressed(_ sender: Any) {
        quizStartDelegate.didStartQuiz()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    
    private func initCommon(){
        Bundle.main.loadNibNamed("QuizView", owner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
        startButton.layer.cornerRadius = 23
        startButton.setTitleColor(Colors.darkPurple, for: .normal)
    }
    
    
    func setup(quiz: QuizCellModel){
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        
        if let url = quiz.imageUrl {
            self.quizImageView.layer.cornerRadius = 10
            self.quizImageView.kf.setImage(with: url)
        }
    }
}
