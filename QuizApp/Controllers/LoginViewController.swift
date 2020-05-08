//
//  LoginController.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var showPassButton: UIButton!
    
    @IBAction func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        login(email: email, password: password)
    }
    
    func login(email: String, password: String) {
        
        let loginService = LoginService()
        loginService.login(username: email, password: password) { (authToken) in
            DispatchQueue.main.async {
                guard let authToken = authToken else { return }
                Authorization.loginUser(authToken: authToken)
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchToHomePage()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        configureTextField(textField: emailTextField)
        configureTextField(textField: passwordTextField)
        
        loginButton.setTitleColor(Colors.purple, for: .normal)
        loginButton.backgroundColor = Colors.white
        loginButton.layer.cornerRadius = 23
    }
    
    func configureTextField(textField: UITextField){
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 23
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.delegate = self
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.attributedPlaceholder?.string ?? "", attributes: [NSAttributedString.Key.foregroundColor: Colors.white_60])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.white.cgColor
        
        if textField == passwordTextField{
            showPassButton.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        
        if textField == passwordTextField{
            if (textField.text?.count ?? 0) == 0 {
                showPassButton.isHidden = true
            } else {
                showPassButton.isHidden = false
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
