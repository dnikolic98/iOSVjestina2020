//
//  TabBarViewController.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        let homePageViewController = HomePageViewController(viewModel: QuizzesViewModel())
        let navigationViewController = UINavigationController(rootViewController: homePageViewController)
        navigationViewController.tabBarItem = UITabBarItem(title: "Quiz", image: #imageLiteral(resourceName: "QuizHome"), tag: 0)
        
        let searchViewController = SearchViewController(viewModel: QuizzesViewModel())
        let searchNavigationViewController = UINavigationController(rootViewController: searchViewController)
        searchNavigationViewController.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "Search"), tag: 0)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "Settings"), tag: 0)
        
        self.viewControllers = [navigationViewController,searchNavigationViewController,settingsViewController]
        
        tabBar.tintColor = Colors.darkPurple
        tabBar.backgroundColor = Colors.white
        
        
    }
    
}
