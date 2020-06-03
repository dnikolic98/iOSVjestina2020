//
//  UIDynamicTableView.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

class UIDynamicTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
