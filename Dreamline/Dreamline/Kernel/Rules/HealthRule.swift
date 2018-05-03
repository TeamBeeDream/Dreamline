//
//  HealthRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class HealthRule: Rule {
    func process(state: KernelState, deltaTime: Double) -> [KernelEvent] {
        if state.flowControl.phase != .play { return [] }
        if state.health.hitPoints <= 0 {
            return [.flowControlPhaseUpdate(phase: .results)]
        } else {
            return []
        }
    }
}
