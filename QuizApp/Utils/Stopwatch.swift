//
//  Stopwatch.swift
//  QuizApp
//
//  Created by five on 31/05/2020.
//  Copyright © 2020 Dario Nikolić. All rights reserved.
//

import Foundation

class Stopwatch {
    var startTime: Date
    var stopTime: Date
    
    init(){
        startTime = Date()
        stopTime = Date()
    }
    
    func start(){
        startTime = Date()
    }
    
    func stop(){
        stopTime = Date()
    }
    
    func getTime() -> Double {
        return Double(stopTime.timeIntervalSince(startTime))
    }
}
