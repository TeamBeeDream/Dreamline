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
}

extension HealthState {
    static func new() -> HealthState {
        return HealthState(hitPoints: 0)
    }
}
