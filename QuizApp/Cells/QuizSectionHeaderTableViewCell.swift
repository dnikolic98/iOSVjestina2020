//
//  QuizSectionHeaderTableViewCell.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class QuizSectionHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
