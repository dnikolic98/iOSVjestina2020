//
//  QuestionView.swift
//  QuizApp
//
//  Created by five on 07/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

protocol QuestionAnsweredDelegate{
    func didAnswerQuestion(isCorrect: Bool)
}

class QuestionView: UIView {
    private var question: Question?
    var questionAnsweredDelegate: QuestionAnsweredDelegate!
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var answerButtons:[UIButton]!
    
    @IBAction private func answerPressed(_ sender: Any) {
        if let pressedButton = sender as? UIButton, let question = self.question {
            var isCorrect: Bool
            let correctAnswer = question.answers[question.correctAnswer]
            
            if pressedButton.titleLabel?.text == correctAnswer{
                correctAnswerAction(button: pressedButton)
                isCorrect = true
            } else {
                let correctButton = getCorrectButton(correctAnswer: correctAnswer)
                incorrectAnswerAction(pressedButton: pressedButton, correctButton: correctButton)
                isCorrect = false
            }
            
            deactivateButtons()
            questionAnsweredDelegate.didAnswerQuestion(isCorrect: isCorrect)
        }
        
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
        Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
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
    
    func deactivateButtons(){
        for button in self.answerButtons{
            button.isEnabled = false
        }
    }
    
    func resetButtons(){
        for button in self.answerButtons{
            button.setTitle("", for: .normal)
        }
    }
    
    func correctAnswerAction(button: UIButton){
        button.backgroundColor = Colors.green
    }
    
    func incorrectAnswerAction(pressedButton: UIButton, correctButton: UIButton){
        pressedButton.backgroundColor = Colors.red
        correctButton.backgroundColor = Colors.green
    }
    
    func getCorrectButton(correctAnswer: String) -> UIButton {
        var correctButton = UIButton()
        for button in self.answerButtons {
            if button.titleLabel?.text == correctAnswer{
                correctButton = button
                break
            }
        }
        return correctButton
    }
    
}
