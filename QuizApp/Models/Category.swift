//
//  Category.swift
//  QuizApp
//
//  Created by five on 08/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation
import UIKit

enum Category: String {
    
    case sports = "Sports"
    case science = "Science"
    
    var color: UIColor {
        switch self {
        case .sports:
            return Colors.gold
        case .science:
            return Colors.lightBlue
        }
    }
}
