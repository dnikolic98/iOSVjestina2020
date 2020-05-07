//
//  HomePage.swift
//  QuizApp
//
//  Created by five on 06/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//


import UIKit

class HomePageController: UIViewController {
    @IBOutlet weak var getQuizButton: UIButton!
    @IBOutlet weak var xCircle: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var erorInfoLabel: UILabel!
    
    @IBAction func getQuizButtonTapped(_ sender: Any) {
        fetchQuizzes()
    }
    
    
    func fetchQuizzes() {
        let quizzesService = QuizzesService()
        quizzesService.fetchQuizzes() { (quizzes) in
            DispatchQueue.main.async {
                if let quizzes = quizzes {
                    print(quizzes)
                    self.hideErrorMessage()
                } else {
                    self.showErrorMessage()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        
        getQuizButton.setTitleColor(Colors.purple, for: .normal)
        getQuizButton.backgroundColor = Colors.white
        getQuizButton.layer.cornerRadius = 23
    }
    
    func showErrorMessage(){
        self.xCircle.isHidden = false
        self.errorLabel.isHidden = false
        self.erorInfoLabel.isHidden = false
    }
    
    func hideErrorMessage(){
        self.xCircle.isHidden = true
        self.errorLabel.isHidden = true
        self.erorInfoLabel.isHidden = true
    }
}
