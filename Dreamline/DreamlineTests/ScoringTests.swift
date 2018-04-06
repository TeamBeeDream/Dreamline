//
//  ScoringTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 3/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class DefaultScoreUpdaterTests: XCTestCase {
    
    // MARK: Test Variables
    
    private var pointsPerBarrier = 2
    private var scoreUpdater: DefaultScoreUpdater!
    private var state: Score!
    private var config: GameConfig!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        self.scoreUpdater = DefaultScoreUpdater()
        self.state = ScoreFactory.getNew()
        self.config = GameConfigFactory.getChallengeConfig()
        self.config.pointsPerBarrier = self.pointsPerBarrier
    }
    
    // MARK: Tests
    
    func testUpdateScoreNoEvents() {
        let events = [Event]()
        let score = self.scoreUpdater.updateScore(state: self.state,
                                                  config: self.config,
                                                  events: events)
        XCTAssert(score.points == 0)
    }
    
    func testUpdateScoreBarrierPass() {
        let events = [Event.barrierPass(0)]
        let score = self.scoreUpdater.updateScore(state: self.state,
                                                  config: self.config,
                                                  events: events)
        XCTAssert(score.points == self.pointsPerBarrier)
    }
    
    func testUpdateScoreMultipleBarrierPasses() {
        let barrierCount = 5
        let events = [Event](repeating: .barrierPass(0), count: barrierCount)
        let score = self.scoreUpdater.updateScore(state: self.state,
                                                  config: self.config,
                                                  events: events)
        XCTAssert(score.points == self.pointsPerBarrier * barrierCount)
    }
}
