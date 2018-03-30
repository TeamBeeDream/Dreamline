//
//  Scoring.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol ScoreUpdater {
    func updateScore(state: Score, config: GameConfig, events: [Event]) -> Score
}

// @RENAME
class DefaultScoreUpdater: ScoreUpdater {
    
    // MARK: Init
    
    static func make() -> ScoreUpdater {
        return DefaultScoreUpdater()
    }
    
    // MARK: ScoreUpdater Methods
    
    func updateScore(state: Score, config: GameConfig, events: [Event]) -> Score {
        var updatedScore = state.clone()
        for event in events {
            switch (event) {
            case .barrierPass(_):
                updatedScore.points += config.pointsPerBarrier
            default: break
            }
        }
        return updatedScore
    }
}
