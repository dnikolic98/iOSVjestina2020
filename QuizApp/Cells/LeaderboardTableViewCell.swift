//
//  LeaderboardTableViewCell.swift
//  QuizApp
//
//  Created by five on 01/06/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(leaderboardCellModel: LeaderboardCellModel) {
        let points = Double(round(100*leaderboardCellModel.points)/100)
        self.positionLabel.text = "\(leaderboardCellModel.position)."
        self.playerLabel.text = leaderboardCellModel.username
        self.pointsLabel.text = "\(points)"
    }
}
