//
//  SearchViewController.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//
import UIKit

class SearchViewController: QuizTableViewBaseController, UITextFieldDelegate {
    
    @IBOutlet private weak var searchTextField: UITextField!
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        bindViewModel()
    }
    
    convenience init(viewModel: QuizzesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false 
        view.addGestureRecognizer(tap)
        
        setupTextField()
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
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
}
