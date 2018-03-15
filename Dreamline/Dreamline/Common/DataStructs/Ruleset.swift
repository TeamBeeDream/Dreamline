//
//  Ruleset.swift
//  Dreamline
//
//  Created by BeeDream on 3/15/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct SpeedInfo {
    let speed: Double
    let points: Int
}

struct Ruleset {
    var speedLookup: [ScrollSpeed: SpeedInfo]
}

class RulesetFactory {
    static func getDefault() -> Ruleset {
        
        var speedLookup = [ScrollSpeed: SpeedInfo]()
        speedLookup[.mach1] = SpeedInfo(speed: 1.0, points: 1)
        speedLookup[.mach2] = SpeedInfo(speed: 1.2, points: 1)
        speedLookup[.mach3] = SpeedInfo(speed: 1.6, points: 2)
        speedLookup[.mach4] = SpeedInfo(speed: 2.0, points: 2)
        speedLookup[.mach5] = SpeedInfo(speed: 2.3, points: 3)
        
        return Ruleset(speedLookup: speedLookup)
    }
}
