//
//  ScrollRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class ScrollRule {
    func calculateScrollDistance(deltaTime: Double,
                                 paused: Bool,
                                 scrollSpeed: Double) -> Double {
        return deltaTime * scrollSpeed * (paused ? 0 : 1)
    }
}

class ScrollRuleAdapter: Rule {
    
    private let rule = ScrollRule()
    
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        let distance = self.rule.calculateScrollDistance(deltaTime: deltaTime,
                                                         paused: state.time.paused,
                                                         scrollSpeed: state.board.scrollSpeed)
        return .boardScroll(distance: distance)
    }
}
