//
//  GameConfig.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum ScrollSpeed: Double {
    case mach1
    case mach2
    case mach3
    case mach4
    case mach5
}

struct SpeedInfo {
    let index: Int
    let speed: Double
    let points: Int
}

// @HACK: this is a pretty janky way to store/deliver information
class ScrollSpeedData {
    static func getData() -> [ScrollSpeed: SpeedInfo] {
        var dict = [ScrollSpeed: SpeedInfo]()
        dict[.mach1] = SpeedInfo(index: 0, speed: 1.2, points: 1)
        dict[.mach2] = SpeedInfo(index: 1, speed: 1.5, points: 1)
        dict[.mach3] = SpeedInfo(index: 2, speed: 2.0, points: 2)
        dict[.mach4] = SpeedInfo(index: 3, speed: 2.6, points: 2)
        dict[.mach5] = SpeedInfo(index: 4, speed: 3.0, points: 3)
        
        return dict
    }
    
    // @HACK
    static func getSpeed(index: Int) -> ScrollSpeed {
        //assert(index >= 0 && index <= 4)
        // @BAD: clamping is not great
        //let i = clamp(index, min: 0, max: 4)
        var i = index
        if index < 0 { i = 0 }
        if index > 4 { i = 4 }
        
        var values = [ScrollSpeed]()
        values.append(.mach1)
        values.append(.mach2)
        values.append(.mach3)
        values.append(.mach4)
        values.append(.mach5)
        
        return values[i]
    }
}

// @RENAME, maybe 'GameModifiers', 'Mutations' ...
struct GameConfig {
    var positionerTolerance: Double
    var positionerMoveDuration: Double
    
    var boardScrollSpeed: ScrollSpeed
    var boardDistanceBetweenTriggers: Double
}

extension GameConfig {
    func clone() -> GameConfig {
        return GameConfig(
            positionerTolerance: self.positionerTolerance,
            positionerMoveDuration: self.positionerMoveDuration,
            boardScrollSpeed: self.boardScrollSpeed,
            boardDistanceBetweenTriggers: self.boardDistanceBetweenTriggers)
    }
}

class GameConfigFactory {
    static func getDefault() -> GameConfig {
        return GameConfig(
            positionerTolerance: 0.2,
            positionerMoveDuration: 0.1,
            boardScrollSpeed: .mach1,
            boardDistanceBetweenTriggers: 0.7)
    }
}
