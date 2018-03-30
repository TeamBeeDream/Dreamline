//
//  DreamlineTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class DynamicSequencerTests: XCTestCase {
    
    var sequencer: Sequencer!
    var mockConfig: GameConfig!
    
    override func setUp() {
        super.setUp()
        
        self.sequencer = DynamicSequencer.make(random: MockConstantRandom.make())
        self.mockConfig = GameConfig(positionerTolerance: 0.0,
                                     positionerMoveDuration: 0.0,
                                     boardScrollSpeed: .mach1,
                                     boardDistanceBetweenEntities: 0.0,
                                     pointsPerBarrier: 0)
    }
    
    override func tearDown() {
        self.sequencer = nil
        super.tearDown()
    }
    
    func testGetNextEntityIsNotNil() {
        XCTAssert(!self.sequencer.getNextEntity(config: self.mockConfig).isEmpty)
    }
}
