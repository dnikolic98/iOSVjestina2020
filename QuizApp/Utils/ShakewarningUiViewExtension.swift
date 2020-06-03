//
//  ShakewarningUiViewExtension.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import UIKit

public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.35,withTranslation translation : Float = 5) {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}
