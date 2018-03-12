//
//  GameConfig.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

enum ScrollSpeed: Double {
    case sp1
    case sp2
    case sp3
    case sp4
    case sp5
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
        dict[.sp1] = SpeedInfo(index: 0, speed: 1.0, points: 1)
        dict[.sp2] = SpeedInfo(index: 1, speed: 1.2, points: 1)
        dict[.sp3] = SpeedInfo(index: 2, speed: 1.4, points: 2)
        dict[.sp4] = SpeedInfo(index: 3, speed: 1.6, points: 2)
        dict[.sp5] = SpeedInfo(index: 4, speed: 1.8, points: 3)
        
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
        values.append(.sp1)
        values.append(.sp2)
        values.append(.sp3)
        values.append(.sp4)
        values.append(.sp5)
        
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
            boardScrollSpeed: .sp1, //1.0,
            boardDistanceBetweenTriggers: 0.7)
    }
}
