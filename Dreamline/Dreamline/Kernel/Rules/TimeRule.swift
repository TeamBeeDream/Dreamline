//
//  TimeRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class TimeRuleAdapter: Rule {
    
    private let adaptedRule: TimeRule
    
    init(_ rule: TimeRule) {
        self.adaptedRule = rule
    }
    
    func process(state: KernelState) -> KernelEvent? {
        let input = (deltaTime: state.time.deltaTime,
                     frameNumber: state.time.frameNumber,
                     timeSinceBeginning: state.time.timeSinceBeginning)
        let output = self.adaptedRule.moveTimeForward(input)
        return .timeUpdate(deltaTime: output.deltaTime,
                           frameNumber: output.frameNumber,
                           timeSinceBeginning: output.timeSinceBeginning)
    }
}

class TimeRule {
    
    typealias Bundle = (deltaTime: Double, frameNumber: Int, timeSinceBeginning: Double)
    
    func moveTimeForward(_ bundle: TimeRule.Bundle) -> TimeRule.Bundle {
        return (deltaTime: bundle.deltaTime,
                frameNumber: bundle.frameNumber + 1,
                timeSinceBeginning: bundle.timeSinceBeginning + bundle.deltaTime)
    }
}
