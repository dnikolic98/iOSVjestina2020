//
//  HomePage.swift
//  QuizApp
//
//  Created by five on 06/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//


import UIKit

class HomePageViewController: UIViewController {
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    var viewModel: QuizzesViewModel!
    var refreshControl: UIRefreshControl!
    var blurView: UIView!
    var questionView: QuestionView!
    
    @IBOutlet weak var getQuizButton: UIButton!
    @IBOutlet weak var xCircle: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var erorInfoLabel: UILabel!
    @IBOutlet weak var funFactDetails: UILabel!
    @IBOutlet weak var funFact: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func getQuizButtonTapped(_ sender: Any) {
        bindViewModel()
    }
    
    convenience init(viewModel: QuizzesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        
        setupGetQuizButton()
        setupTableView()
        setupBlurView()
        setupQuestionView()
    }
    
    func setupGetQuizButton(){
        getQuizButton.setTitleColor(Colors.purple, for: .normal)
        getQuizButton.backgroundColor = Colors.white
        getQuizButton.layer.cornerRadius = 23
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomePageViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    func setupBlurView(){
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.isHidden = true
        view.addSubview(blurView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        blurView.addGestureRecognizer(tap)
    }
    
    func setupQuestionView(){
        questionView = QuestionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 340, height: 410)))
        questionView.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height / 2)
        questionView.clipsToBounds = true
        questionView.layer.cornerRadius = 10
        questionView.sizeToFit()
        questionView.isHidden = true
        questionView.deactivateButtons()
        view.addSubview(questionView)
    }
    
    func bindViewModel() {
        viewModel.fetchQuizzes() { (quizzes) in
            if quizzes != nil{
                self.refresh()
                DispatchQueue.main.async {
                    self.showFunFact(word: "NBA")
                    self.hideErrorMessage()
                    self.tableView.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.showErrorMessage()
                    self.hideFunFact()
                    self.tableView.isHidden = true
                }
            }
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        hideDetailScreen()
    }
    
    func showDetailScreen(question: Question) {
        questionView.loadData(question: question)
        blurView.isHidden = false
        questionView.isHidden = false
    }
    
    func hideDetailScreen() {
        questionView.isHidden = true
        blurView.isHidden = true
        questionView.resetButtons()
    }
    
    func showFunFact(word: String){
        if let fact = viewModel.getFunFact(forWord: word){
            self.funFactDetails.text = fact
            self.funFactDetails.isHidden = false
            self.funFact.isHidden = false
        }
    }
    
    func hideFunFact() {
        self.funFactDetails.isHidden = true
        self.funFact.isHidden = true
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


extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = Category.allCases[section]
        let headerView = Bundle.main.loadNibNamed("QuizSectionHeaderTableViewCell", owner: self, options: nil)?.first as! QuizSectionHeaderTableViewCell
        if viewModel.numberOfQuizzes() != 0 {
            headerView.categoryLabel.text = category.rawValue
            headerView.categoryLabel.textColor = category.color
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let quiz = viewModel.getQuiz(indexPath: indexPath)
        if let question = quiz?.getQuestionPreview() {
            showDetailScreen(question: question)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        let horizontalPadding: CGFloat = 20
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: horizontalPadding/2, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}

extension HomePageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableViewCell
        if let quizCellModel = viewModel.quiz(indexPath: indexPath) {
            cell.setup(quiz: quizCellModel)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Category.allCases[section]
        return viewModel.numberOfQuizzesInCategory(category: category)
    }
}