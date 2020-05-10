//
//  QuizTableVIewCell.swift
//  QuizApp
//
//  Created by five on 09/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation
import UIKit

class QuizTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var quizImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var levelIcons: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLevelIcons()
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
    
    func setup(quiz: QuizCellModel) {
        self.titleLabel.text = quiz.title
        self.descriptionLabel.text = quiz.description
        
        for i in 0...(quiz.level-1){
            self.levelIcons[i].tintColor = quiz.category.color
        }
        
        let quizImageService = QuizImageService()
        quizImageService.fetchImage(quiz: quiz) { (image) in
            DispatchQueue.main.async {
                self.quizImageView.image = image
            }
            
        }
    }
    
    private func configureLevelIcons(){
        for icon in self.levelIcons{
            icon.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
            icon.tintColor = Colors.white_30
        }
    }
    
}
