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
    @IBOutlet weak var funFactDetails: UILabel!
    @IBOutlet weak var funFact: UILabel!
    
    @IBAction func getQuizButtonTapped(_ sender: Any) {
        fetchQuizzes()
    }
    
    func fetchQuizzes() {
        let quizzesService = QuizzesService()
        quizzesService.fetchQuizzes() { (quizzes) in
            DispatchQueue.main.async {
                if let quizzes = quizzes {
                    self.showFunFact(quizzes: quizzes, word: "NBA")
                    self.hideErrorMessage()
//                    self.showDetailScreen(question: quizzes[0].questions[0])
                } else {
                    self.showErrorMessage()
                    self.hideFunFact()
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
    
    func showFunFact(quizzes : [Quiz], word: String){
        var questions = [String]()
        
        for quiz in quizzes{
            questions.append(contentsOf: quiz.questions.compactMap{$0.question}.filter{$0.contains(word)})
        }
        
        let fact = "There are \(questions.count) questions that contain the word \"\(word)\""
        self.funFactDetails.text = fact
        
        self.funFactDetails.isHidden = false
        self.funFact.isHidden = false
    }
    
    func hideFunFact() {
        self.funFactDetails.isHidden = true
        self.funFact.isHidden = true
    }
    
    func showDetailScreen(question: Question) {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
        let questionView = QuestionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 340, height: 410)))
        questionView.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
        questionView.clipsToBounds = true
        questionView.layer.cornerRadius = 10
        questionView.loadData(question: question)
        questionView.sizeToFit()
        view.addSubview(questionView)
    }
}
