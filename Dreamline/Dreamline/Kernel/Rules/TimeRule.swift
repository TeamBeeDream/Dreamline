//
//  TimeRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class TimeRule: Rule {
    
    private let calculator = TimeCalculator()
    
    func process(state: KernelState, deltaTime: Double) -> [KernelEvent] {
        let input = (deltaTime: deltaTime,
                     frameNumber: state.time.frameNumber,
                     timeSinceBeginning: state.time.timeSinceBeginning)
        let output = self.calculator.moveTimeForward(input)
        return [.timeUpdate(deltaTime: output.deltaTime,
                            frameNumber: output.frameNumber,
                            timeSinceBeginning: output.timeSinceBeginning)]
    }
}

class TimeCalculator {
    
    typealias Bundle = (deltaTime: Double, frameNumber: Int, timeSinceBeginning: Double)
    
    func moveTimeForward(_ bundle: TimeCalculator.Bundle) -> TimeCalculator.Bundle {
        return (deltaTime: bundle.deltaTime,
                frameNumber: bundle.frameNumber + 1,
                timeSinceBeginning: bundle.timeSinceBeginning + bundle.deltaTime)
    }
}
