//
//  Scoring.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @RENAME
// should probably have a term for "set of functions
// that modifies the state"
protocol ScoreUpdater {
    func updateScore(state: Score, config: GameConfig, ruleset: Ruleset, events: [Event]) -> Score
}

// @RENAME
class DefaultScoreUpdater: ScoreUpdater {
    func updateScore(state: Score, config: GameConfig, ruleset: Ruleset, events: [Event]) -> Score {
        
        var updatedScore = state.clone()
        
        for event in events {
            switch (event) {
            case .barrierPass(_):
                updatedScore.points += ruleset.speedLookup[config.boardScrollSpeed]!.points
            default: break
            }
        }
        
        return updatedScore
    }
}
