//
//  SearchViewController.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate{
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var viewModel: QuizzesViewModel!
    private var refreshControl: UIRefreshControl!
    private var blurView: UIView!
    private var questionView: QuestionView!
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        bindViewModel()
    }
    
    convenience init(viewModel: QuizzesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false 
        view.addGestureRecognizer(tap)
        
        setupTextField()
        setupTableView()
        setupBlurView()
        setupQuestionView()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SearchViewController.refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "QuizTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        tableViewHeightConstraint.constant = CGFloat(0)
    }
    
    private func setupBlurView(){
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.frame
        blurView.isHidden = true
        view.addSubview(blurView)
    }
    
    private func setupQuestionView(){
        let deviceWidth = UIScreen.main.bounds.size.width
        let deviceHeight = UIScreen.main.bounds.size.height
        let frameSize: CGPoint = CGPoint(x: deviceWidth*0.5, y: deviceHeight*0.5)
        
        questionView = QuestionView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: deviceWidth*0.8, height: 500)))
        questionView.center = frameSize
        questionView.clipsToBounds = true
        questionView.layer.cornerRadius = 10
        questionView.sizeToFit()
        questionView.isHidden = true
        questionView.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        questionView.deactivateButtons()
        view.addSubview(questionView)
    }
    
    private func setupTextField(){
        searchTextField.clipsToBounds = true
        searchTextField.layer.cornerRadius = 23
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: searchTextField.frame.size.height))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        searchTextField.delegate = self
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.clear.cgColor
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: searchTextField.attributedPlaceholder?.string ?? "", attributes: [NSAttributedString.Key.foregroundColor: Colors.white_60])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func bindViewModel() {
        guard let filterString = searchTextField.text else { return }
        viewModel.fetchAndFilter(filter: filterString) { (quizzes) in
            if quizzes != nil{
                self.refresh()
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.refreshTableViewHeight()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.isHidden = true
                    self.tableViewHeightConstraint.constant = CGFloat(0)
                }
            }
        }
    }
    
    @objc private func refresh() {
        DispatchQueue.main.async {
            self.refreshTableViewHeight()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func refreshTableViewHeight(){
        let rowHeight = 170
        let sectionHeight = 50
        
        let rows = viewModel.numberOfQuizzes()
        let sections = Category.allCases.count
        
        tableViewHeightConstraint.constant = CGFloat(rows * rowHeight + sections * sectionHeight)
    }
    
    private func showDetailScreen(question: Question) {
        questionView.loadData(question: question)
        blurView.isHidden = false
        if questionView.isHidden{
            questionView.animateScaleToSize(scaleFrom: 0.5, scaleTo: 1.0, duration: 0.15)
        }
        questionView.isHidden = false
    }
    
    private func hideDetailScreen() {
        questionView.isHidden = true
        blurView.isHidden = true
        questionView.resetButtons()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let category = Category.allCases[section]
        let headerView = Bundle.main.loadNibNamed("QuizSectionHeaderTableViewCell", owner: self, options: nil)?.first as! QuizSectionHeaderTableViewCell
        if viewModel.numberOfQuizzesInCategory(category: category) != 0 {
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
        
        if let selectedQuiz = viewModel.quiz(indexPath: indexPath){
            
            
            let quizViewController = QuizViewController(quiz: selectedQuiz)
            navigationController?.pushViewController(quizViewController, animated: true)
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

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! QuizTableViewCell
        if let quizCellModel = viewModel.quiz(indexPath: indexPath) {
            cell.setup(quiz: quizCellModel)
            cell.previewQuestionDelegate = self
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

extension SearchViewController: PreviewQuestionDelegate {
    func didPreviewQuestionStart(question: Question) {
        showDetailScreen(question: question)
    }
    
    func didPreviewQuestionEnd() {
        hideDetailScreen()
    }
    
}
