//
//  Ruleset.swift
//  Dreamline
//
//  Created by BeeDream on 3/15/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @ROBUSTNESS: Should probably find a better way to couple
//              Speed enum to actual usable data
struct SpeedInfo {
    let speed: Double
    let points: Int
}

struct Ruleset {
    var speedLookup: [Speed: SpeedInfo]
}

class RulesetFactory {
    static func getDefault() -> Ruleset {
        var speedLookup = [Speed: SpeedInfo]()
        //speedLookup[.mach1] = SpeedInfo(speed: 0.8, points: 1)
        speedLookup[.mach1] = SpeedInfo(speed: 2.0, points: 1) // @HACK
        speedLookup[.mach2] = SpeedInfo(speed: 0.9, points: 1)
        speedLookup[.mach3] = SpeedInfo(speed: 1.1, points: 2)
        speedLookup[.mach4] = SpeedInfo(speed: 1.3, points: 2)
        speedLookup[.mach5] = SpeedInfo(speed: 1.5, points: 3)
        speedLookup[.mach6] = SpeedInfo(speed: 1.8, points: 3)
        speedLookup[.mach7] = SpeedInfo(speed: 2.0, points: 4)
        speedLookup[.mach8] = SpeedInfo(speed: 2.1, points: 4)
        speedLookup[.mach9] = SpeedInfo(speed: 2.2, points: 5)
        
        return Ruleset(speedLookup: speedLookup)
    }
}
