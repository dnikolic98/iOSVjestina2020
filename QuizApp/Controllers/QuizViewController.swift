//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    var quiz: QuizCellModel!
    var leaderboardView: LeaderboardView!

    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var quizView: QuizView!
    
    @IBAction func leaderboardPressed(_ sender: Any) {
        showLeaderboard()
    }
    
    convenience init(quiz: QuizCellModel){
        self.init()
        self.quiz = quiz
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        leaderboardButton.addBottomBorder(Colors.white, height: 3)
        
        setupQuizView()
        setupNavbar()
        setupLeaderboardView()
    }
    
    private func setupQuizView(){
        quizView.setup(quiz: quiz)
        quizView.layer.cornerRadius = 10
        quizView.clipsToBounds = true
        quizView.quizStartDelegate = self
    }
    
    private func setupNavbar(){
        navigationItem.title = "PopQuiz"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SourceSansPro-Bold", size: 24)!]
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = Colors.white
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        
        let yourBackImage = #imageLiteral(resourceName: "Back Button")
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.tintColor = Colors.white
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func setupLeaderboardView(){
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let frameSize: CGPoint = CGPoint(x: deviceWidth*0.5, y: deviceHeight*0.5)
        
        leaderboardView = LeaderboardView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: deviceWidth, height: deviceHeight)))
        leaderboardView.center = frameSize
        leaderboardView.clipsToBounds = true
        leaderboardView.sizeToFit()
        leaderboardView.isHidden = true
//        view.addSubview(leaderboardView)
        leaderboardView.frame = UIApplication.shared.keyWindow!.frame
        UIApplication.shared.keyWindow!.addSubview(leaderboardView)
        
        leaderboardView.leaderboardDelegate = self
    }
    
    func showLeaderboard(){
        leaderboardView.isHidden = false
    }
    
    func hideLeaderboard(){
        leaderboardView.isHidden = true
    }
}

extension QuizViewController: LeaderboardDelegate{
    func didCloseLeaderboard() {
        hideLeaderboard()
    }
}

extension QuizViewController: QuizStartDelegate{
    func didStartQuiz() {
    }
}
