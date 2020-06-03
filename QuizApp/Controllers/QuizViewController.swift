//
//  QuizViewController.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    private var quiz: QuizCellModel!
    private var leaderboardView: LeaderboardView!
    
    @IBOutlet private weak var leaderboardButton: UIButton!
    @IBOutlet private weak var quizView: QuizView!
    
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
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    private func setupLeaderboardView(){
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let frameSize: CGPoint = CGPoint(x: deviceWidth*0.5, y: deviceHeight*0.5)
        
        leaderboardView = LeaderboardView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: deviceWidth, height: deviceHeight)))
        leaderboardView.center = frameSize
        leaderboardView.clipsToBounds = true
        leaderboardView.sizeToFit()
        leaderboardView.isHidden = true
        
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        leaderboardView.frame = keyWindow!.frame
        keyWindow!.addSubview(leaderboardView)
        
        leaderboardView.leaderboardDelegate = self
        leaderboardView.setupLeaderboard(quizId: quiz.id)
    }
    
    private func showLeaderboard(){
        leaderboardView.animateInFromBottom()
        leaderboardView.refresh()
    }
    
    private func hideLeaderboard(){
        leaderboardView.animateOutToBottom()
    }
}

extension QuizViewController: LeaderboardDelegate{
    func didCloseLeaderboard() {
        hideLeaderboard()
    }
}

extension QuizViewController: QuizStartDelegate{
    func didStartQuiz() {
        let startedQuizViewController = StartedQuizViewController(quiz: quiz)
        navigationController?.pushViewController(startedQuizViewController, animated: true)
    }
}
