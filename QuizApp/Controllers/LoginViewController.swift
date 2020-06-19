//
//  LoginController.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    private let animationDelay = 0.15
    private let animationDuration = 0.5
    
    @IBOutlet private weak var appLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var showPassButton: UIButton!
    @IBOutlet private weak var passwrodVerticalConstraint: NSLayoutConstraint!
    
    @IBAction private func showPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        if passwordTextField.isSecureTextEntry {
            showPassButton.tintColor = Colors.white_60
        } else {
            showPassButton.tintColor = Colors.white
        }
    }
    
    @IBAction private func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if email.count == 0 {
            emailTextField.shake()
            return
        }
        if password.count == 0 {
            passwordTextField.shake()
            self.showPassButton.shake()  
            return
        }
        
        login(email: email, password: password)
    }
    
    private func login(email: String, password: String) {
        
        let loginService = LoginService()
        loginService.login(username: email, password: password) { (authToken) in
            DispatchQueue.main.async {
                guard let authToken = authToken else {
                    self.passwordTextField.shake()
                    self.showPassButton.shake()
                    return
                }
                Authorization.loginUser(authToken: authToken)
                
                self.animateOutAndSwitch()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setupTextField(textField: emailTextField)
        setupTextField(textField: passwordTextField)
        setupLoginButton()
        showPassButton.tintColor = Colors.white_60
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appLabel.animateScaleToSize(scaleFrom: 0.0, scaleTo: 1.0, duration: animationDuration)
        emailTextField.animateInFromLeft(duration: animationDuration, delay: 0.0)
        emailTextField.animateInFromLeft(duration: animationDuration, delay: animationDelay)
        passwordTextField.animateInFromLeft(duration: animationDuration, delay: animationDelay*2)
        loginButton.animateInFromLeft(duration: animationDuration, delay: animationDelay*3)
    }
    
    private func animateOutAndSwitch(){
        view.removeConstraint(passwrodVerticalConstraint)
        
        appLabel.animateOutToTop(duration: animationDuration, delay: 0.0)
        emailTextField.animateOutToTop(duration: animationDuration, delay: animationDelay)
        passwordTextField.animateOutToTop(duration: animationDuration, delay: animationDelay*2)
        showPassButton.animateOutToTop(duration: animationDuration, delay: animationDelay*2)
        loginButton.animateOutToTop(duration: animationDuration, delay: animationDelay*3)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay*3 + animationDuration) {
            self.switchToHomePage()
        }
    }
    
    private func switchToHomePage(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchToHomePage()
    }
    
    private func setupLoginButton(){
        loginButton.setTitleColor(Colors.darkPurple, for: .normal)
        loginButton.backgroundColor = Colors.white
        loginButton.layer.cornerRadius = 23
    }
    
    private func setupTextField(textField: UITextField){
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 10
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
