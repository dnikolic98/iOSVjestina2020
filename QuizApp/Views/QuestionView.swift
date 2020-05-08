//
//  QuestionView.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    private var question: Question?
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var answerButtons:[UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    
    private func initCommon(){
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        for button in self.answerButtons{
            button.layer.cornerRadius = 23
        }
    }
    
    func loadData(question: Question){
        self.question = question
        
        self.questionLabel.text = self.question?.question
        for (index, button) in self.answerButtons.enumerated(){
            button.setTitle(self.question?.answers[index], for: .normal)
        }
    }
}
