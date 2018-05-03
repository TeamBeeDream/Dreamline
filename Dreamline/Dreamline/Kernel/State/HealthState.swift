//
//  HealthState.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct HealthState {
    var hitPoints: Int
    var invincible: Bool
    var totalBarriers: Int
    var barriersPassed: Int
}

extension HealthState {
    static func new() -> HealthState {
        return HealthState(hitPoints: 0,
                           invincible: false,
                           totalBarriers: 0,
                           barriersPassed: 0)
    }
}
