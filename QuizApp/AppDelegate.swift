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
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = HomePageController()
        
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        
        return true
    }


}

