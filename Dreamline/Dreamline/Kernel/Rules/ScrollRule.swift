//
//  ScrollRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class ScrollRule: Rule {
    
    private let calculator = ScrollDistanceCalculator()
    
    func process(state: KernelState, deltaTime: Double) -> [KernelEvent] {
        let distance = self.calculator.calculateScrollDistance(deltaTime: deltaTime,
                                                               paused: state.time.paused,
                                                               scrollSpeed: state.board.scrollSpeed)
        return [.boardScroll(distance: distance)]
    }
}

class ScrollDistanceCalculator {
    func calculateScrollDistance(deltaTime: Double,
                                 paused: Bool,
                                 scrollSpeed: Double) -> Double {
        return deltaTime * scrollSpeed * (paused ? 0 : 1)
    }
}
