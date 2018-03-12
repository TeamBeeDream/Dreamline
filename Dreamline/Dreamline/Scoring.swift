//
//  Scoring.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct Score {
    var points: Int
}

extension Score {
    func clone() -> Score {
        return Score(points: self.points)
    }
}

class ScoreFactory {
    static func getNew() -> Score {
        return Score(points: 0)
    }
}

// @RENAME
// should probably have a term for "set of functions
// that modifies the state"
protocol ScoreUpdater {
    func updateScore(state: Score, config: GameConfig, events: [Event]) -> Score
}

// @RENAME
class DefaultScoreUpdater: ScoreUpdater {
    func updateScore(state: Score, config: GameConfig, events: [Event]) -> Score {
        
        var updatedScore = state.clone()
        
        for event in events {
            switch (event) {
            case .barrierPass(_):
                updatedScore.points += howManyPoints(speed: config.boardScrollSpeed)
            default: break
            }
        }
        
        return updatedScore
    }
    
    // @HARDCODED: converts ScrollSpeed enum to point value
    // should probably be defined somewhere else
    private func howManyPoints(speed: ScrollSpeed) -> Int {
        return ScrollSpeedData.getData()[speed]!.points // hahaha
    }
}
