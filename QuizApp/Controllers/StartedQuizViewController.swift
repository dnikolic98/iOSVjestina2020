//
//  StartedQuizViewController.swift
//  QuizApp
//
//  Created by five on 31/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class StartedQuizViewController: UIViewController {
    var quiz: QuizCellModel!
    var answers = [Bool]()
    var questionIndicatorViews = [UIView]()
    var stopwatch: Stopwatch!
    
    @IBOutlet weak var questionScrollView: UIScrollView!
    @IBOutlet weak var questionIndicatorStackView: UIStackView!
    @IBOutlet weak var questionNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        
        setupNavbar()
        setupQuestionViews()
        setupQuestionIndicatorStackView()
        stopwatch.start()
    }
    
    convenience init(quiz: QuizCellModel){
        self.init()
        self.quiz = quiz
        self.stopwatch = Stopwatch()
    }
    
    private func setupQuestionViews() {
        let quizScrollViewWidth = self.questionScrollView.frame.width
        
        quiz.questions.enumerated().forEach {
            let offset = quizScrollViewWidth * CGFloat($0)
            let questionView = QuestionView(
                frame: CGRect(origin: CGPoint(x: offset, y: 0),
                              size: questionScrollView.frame.size))
            questionView.loadData(question: $1)
            questionView.questionAnsweredDelegate = self
            questionScrollView.addSubview(questionView)
        }
    }
    
    private func setupNavbar(){
        navigationItem.title = "PopQuiz"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func focusQuestionIndicator(questionNumber index: Int){
        questionIndicatorViews[index].backgroundColor = Colors.white
    }
    
    private func correctQuestionIndicator(questionNumber index: Int){
        questionIndicatorViews[index].backgroundColor = Colors.green
    }
    
    private func incorrectQuestionIndicator(questionNumber index: Int){
        questionIndicatorViews[index].backgroundColor = Colors.red
    }
    
    private func setupQuestionIndicatorStackView(){
        let stackViewHeight = questionIndicatorStackView.layer.bounds.height
        
        for _ in 0..<quiz.questions.count {
            let indicatorView = generateQuestionIndicatorView(color: Colors.white_50, height: stackViewHeight)
            questionIndicatorViews.append(indicatorView)
            questionIndicatorStackView.addArrangedSubview(indicatorView)
        }
        
        focusQuestionIndicator(questionNumber: 0)
        refreshQuestionNumberLabel()
    }
    
    private func generateQuestionIndicatorView(color: UIColor, height: CGFloat) -> UIView{
        let indicator = UIView()
        indicator.backgroundColor = color
        indicator.layer.cornerRadius = height/2
        return indicator
    }
    
    private func refreshQuestionNumberLabel(){
        let numOfQuestions = quiz.questions.count
        let currentQuestion = answers.count + 1
        
        questionNumberLabel.text = "\(currentQuestion)/\(numOfQuestions)"
    }
    
    private func answeredQuestionLogic(isCorrect: Bool, questionNumber index: Int){
        answers.append(isCorrect)
        
        if isCorrect{
            correctQuestionIndicator(questionNumber: index)
        } else {
            incorrectQuestionIndicator(questionNumber: index)
        }
        
    }
    
    private func autoScroll(){
        let offset = questionScrollView.frame.width * CGFloat(answers.count)
        questionScrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
    
    private func postResults() {
        let quizId = quiz.id
        let numberOfCorrectAnswers = answers.filter{$0}.count
        let quizTime = stopwatch.getTime()
        
        let quizService = QuizzesService()
        quizService.postResult(
            quizId: quizId,
            numberOfCorrect: numberOfCorrectAnswers,
            time: quizTime,
            completion: { (httpStatusCode) in
                if let httpStatusCode = httpStatusCode {
                    if httpStatusCode == HttpStatusCode.OK {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewControllers(viewsToPop: 2)
                        }
                    } else {
                        self.showErrorDialog(message: httpStatusCode.message)
                    }
                } else {
                    self.showErrorDialog(message: "Server did not respond")
                }
        })
    }
    
    private func showErrorDialog(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let resendAction = UIAlertAction(title: "Resend", style: .default) { (_) in self.postResults() }
        alert.addAction(resendAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension StartedQuizViewController: QuestionAnsweredDelegate {
    func didAnswerQuestion(isCorrect: Bool) {
        answeredQuestionLogic(isCorrect: isCorrect, questionNumber: answers.count)
        
        
        let seconds = 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.autoScroll()
            
            if self.answers.count == self.quiz.questions.count {
                self.stopwatch.stop()
                self.postResults()
            } else {
                self.focusQuestionIndicator(questionNumber: self.answers.count)
                self.refreshQuestionNumberLabel()
            }
        }
    }
}
