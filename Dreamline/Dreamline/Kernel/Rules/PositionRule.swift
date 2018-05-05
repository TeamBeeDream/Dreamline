//
//  PositionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class PositionRule: Rule {
    
    private var calculator = PositionCalculator()
    static let MOVE_DURATION: Double = 0.1
    
    func process(state: KernelState, deltaTime: Double) -> [KernelEvent] {
        let position = self.calculator.calculateNewPosition(deltaTime: deltaTime,
                                                            moveDuration: 0.1,  // @HARDCODED
                                                            originalState: state.position)
        return [.positionUpdate(distanceFromOrigin: position)]
    }
}

class PositionCalculator {
    func calculateNewPosition(deltaTime: Double,
                              moveDuration: Double,
                              originalState: PositionState) -> Double {
        let target = Double(originalState.targetLane)
        let diff = target - originalState.distanceFromOrigin
        let step = clamp(deltaTime / moveDuration,
                         min: 0.0, max: 1.0)
        let delta = step * diff
        return originalState.distanceFromOrigin + delta
    }
}
