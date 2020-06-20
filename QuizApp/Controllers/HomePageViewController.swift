//
//  HomePage.swift
//  QuizApp
//
//  Created by five on 06/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//


import UIKit

class HomePageViewController: QuizTableViewBaseController {
    
    @IBOutlet private weak var getQuizButton: UIButton!
    @IBOutlet private weak var xCircle: UIImageView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var erorInfoLabel: UILabel!
    @IBOutlet private weak var funFactDetails: UILabel!
    @IBOutlet private weak var funFact: UILabel!
    
    @IBAction func getQuizButtonTapped(_ sender: Any) {
        bindViewModel()
    }
    
    convenience init(viewModel: QuizzesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGetQuizButton()
    }
    
    private func setupGetQuizButton(){
        getQuizButton.setTitleColor(Colors.darkPurple, for: .normal)
        getQuizButton.backgroundColor = Colors.white
        getQuizButton.layer.cornerRadius = 23
    }
    
    private func bindViewModel() {
        viewModel.fetchQuizzes() { (quizzes) in
            if quizzes != nil{
                self.refresh()
                DispatchQueue.main.async {
                    self.showFunFact(word: "NBA")
                    self.hideErrorMessage()
                    self.tableView.isHidden = false
                    self.refreshTableViewHeight()
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorMessage()
                    self.hideFunFact()
                    self.tableView.isHidden = true
                    self.tableViewHeightConstraint.constant = CGFloat(0)
                }
            }
        }
    }
    
    private func showFunFact(word: String){
        if let fact = viewModel.getFunFact(forWord: word){
            self.funFactDetails.text = fact
            self.funFactDetails.isHidden = false
            self.funFact.isHidden = false
        }
    }
    
    private func hideFunFact() {
        self.funFactDetails.isHidden = true
        self.funFact.isHidden = true
    }
    
    
    private func showErrorMessage(){
        self.xCircle.isHidden = false
        self.errorLabel.isHidden = false
        self.erorInfoLabel.isHidden = false
    }
    
    private func hideErrorMessage(){
        self.xCircle.isHidden = true
        self.errorLabel.isHidden = true
        self.erorInfoLabel.isHidden = true
    }
    
}
