//
//  LeaderboardView.swift
//  QuizApp
//
//  Created by five on 29/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

protocol LeaderboardDelegate {
    func didCloseLeaderboard()
}

class LeaderboardView: UIView {
    var leaderboardDelegate: LeaderboardDelegate!
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var leaderboardTableView: UITableView!
    
    
    @IBAction func CloseLeaderboardAction(_ sender: Any) {
        leaderboardDelegate.didCloseLeaderboard()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    private func initCommon(){
        Bundle.main.loadNibNamed("LeaderboardView", owner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        
        view.setGradientBackground(colorOne: Colors.lightPurple, colorTwo: Colors.darkBlue)
    }

}
