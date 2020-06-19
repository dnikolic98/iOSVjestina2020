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
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var viewModel: LeaderboardViewModel!
    var leaderboardDelegate: LeaderboardDelegate!
    private var quizId: Int!
    private var refreshControl: UIRefreshControl!
    
    @IBOutlet private var view: UIView!
    @IBOutlet private weak var leaderboardTableView: UITableView!
    
    @IBAction private func CloseLeaderboardAction(_ sender: Any) {
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
    
    public func setupLeaderboard(quizId: Int){
        self.quizId = quizId
        viewModel = LeaderboardViewModel(quizId: quizId)
        bindViewModel()
        setupTableView()
    }
    
    private func setupTableView() {
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LeaderboardView.refresh), for: UIControl.Event.valueChanged)
        leaderboardTableView.refreshControl = refreshControl
        
        leaderboardTableView.register(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.leaderboardTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func bindViewModel() {
        viewModel.fetchScores() { (scores) in
            if scores != nil{
                self.refresh()
            }
        }
    }
}

extension LeaderboardView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("LeaderboardSectionHeaderTableViewCell", owner: self, options: nil)?.first as! UITableViewCell
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LeaderboardView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! LeaderboardTableViewCell
        if let leaderboardCellModel = viewModel.getScore(indexPath: indexPath){
            cell.setup(leaderboardCellModel: leaderboardCellModel)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfScores()
    }
}

