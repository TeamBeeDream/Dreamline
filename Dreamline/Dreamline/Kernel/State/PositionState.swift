//
//  PositionState.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct PositionState {
    var nearestLane: Int
    var distanceFromNearestLane: Double
    var distanceFromOrigin: Double
    var targetLane: Int
}

extension PositionState {
    static func new() -> PositionState {
        return PositionState(nearestLane: 0,
                             distanceFromNearestLane: 0.0,
                             distanceFromOrigin: 0.0,
                             targetLane: 0)
    }
}
