//
//  Time.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct TimeData {
    var timeSinceBeginning: Double
    var frameNumber: Int
    var deltaTime: Double
    var paused: Bool
    
    static func new() -> TimeData {
        return TimeData(timeSinceBeginning: 0.0,
                        frameNumber: 0,
                        deltaTime: 0.0,
                        paused: false)
    }
    
    static func clone(_ data: TimeData) -> TimeData {
        return TimeData(timeSinceBeginning: data.timeSinceBeginning,
                        frameNumber: data.frameNumber,
                        deltaTime: data.deltaTime,
                        paused: data.paused)
    }
}
