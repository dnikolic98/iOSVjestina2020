//
//  QuizFinishedView.swift
//  QuizApp
//
//  Created by five on 01/06/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class QuizFinishedView: UIView {
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    
    private func initCommon(){
        Bundle.main.loadNibNamed("QuizFinishedView", owner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
    }
    
    public func setup(numOfCorrect: Int, numOfQuestions: Int){
        var message = ""
        
        let score = Double(numOfCorrect)/Double(numOfQuestions)
        if score < 0.3 {
            message = "Try a bit harder!"
        } else if score >= 0.3 && score < 0.5 {
            message = "Better luck next time!"
        } else if score >= 0.5 && score < 0.7 {
            message = "Not bad!"
        } else if score >= 0.7 {
            message = "Good job!"
        }
        
        scoreLabel.text = "\(numOfCorrect)/\(numOfQuestions)"
        messageLabel.text = message
    }
}
