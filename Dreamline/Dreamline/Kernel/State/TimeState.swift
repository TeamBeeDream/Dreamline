//
//  TimeState.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct TimeState {
    var deltaTime: Double
    var timeSinceBeginning: Double
    var frameNumber: Int
    var paused: Bool
}

extension TimeState {
    static func new() -> TimeState {
        return TimeState(deltaTime: 0.0,
                         timeSinceBeginning: 0.0,
                         frameNumber: 0,
                         paused: false)
    }
}
