//
//  AppDelegate.swift
//  QuizApp
//
//  Created by five on 05/05/2020.
//  Copyright © 2020 five. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = Authorization.isLoggedIn() ? HomePageViewController(viewModel: QuizzesViewModel()) : LoginViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func switchToLogin(){
        self.window?.rootViewController = LoginViewController()
    }
    
    func switchToHomePage() {
        self.window?.rootViewController = HomePageViewController(viewModel: QuizzesViewModel())
    }

}

