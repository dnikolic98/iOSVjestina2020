//
//  QuizTableVIewCell.swift
//  QuizApp
//
//  Created by five on 09/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit
import Kingfisher

protocol PreviewQuestionDelegate {
    func didPreviewQuestionStart(question: Question)
    func didPreviewQuestionEnd()
}

class QuizTableViewCell: UITableViewCell {
    var questions: [Question]!
    var previewQuestionDelegate: PreviewQuestionDelegate!
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var levelIcons: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLevelIcons()
        self.setupGestureRecognizer()
        self.quizImageView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.quizImageView?.image = nil
        for icon in self.levelIcons{
            icon.tintColor = Colors.white_30
        }
    }
    
    func setupGestureRecognizer(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.addGestureRecognizer(lpgr)
    }
    
    func setup(quiz: QuizCellModel) {
        self.questions = quiz.questions
        self.titleLabel.text = quiz.title
        self.descriptionLabel.text = quiz.description
        
        for i in 0...(quiz.level-1){
            self.levelIcons[i].tintColor = quiz.category.color
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = quiz.category.color
        self.selectedBackgroundView = bgColorView
        
        
        if let url = quiz.imageUrl {
            self.quizImageView.kf.setImage(with: url)
        }
    }
    
    private func setupLevelIcons(){
        for icon in self.levelIcons{
            icon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            icon.tintColor = Colors.white_30
        }
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            if let question = self.getQuestionPreview() {
                previewQuestionDelegate.didPreviewQuestionStart(question: question)
            }
        } else {
            previewQuestionDelegate.didPreviewQuestionEnd()
        }
    }
    
    func getQuestionPreview() -> Question?{
        if self.questions.count == 0{
            return nil
        }
        return self.questions[0]
    }
}
