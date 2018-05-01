//
//  SpawnRuleTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class SpawnRegulatorTests: XCTestCase {
    
    private var regulator = SpawnRegulator()
    private var shouldSpawn: Bool!
    private var entityPosition: Double!
    
    private var boardPosition: Double!
    private var distanceBetweenBarriers: Double!
    private var lastEntityPosition: Double!
    
    func testShouldSpawnEntity_True() {
        self.setupBoardForTrue()
        self.triggerRegulator()
        self.assertShouldSpawn(true)
    }
    
    func testShouldSpawnEntity_False() {
        self.setupBoardForFalse()
        self.triggerRegulator()
        self.assertShouldSpawn(false)
    }
    
    func testGetSpawnPosition() {
        self.setupBoardForTrue()
        self.getNextEntityPosition()
        self.assertEntityPosition()
    }
    
    private func setupBoardForTrue() {
        self.distanceBetweenBarriers = 1.0
        self.lastEntityPosition = 0.0
        self.boardPosition = 1.5
    }
    
    private func setupBoardForFalse() {
        self.distanceBetweenBarriers = 1.0
        self.lastEntityPosition = 0.0
        self.boardPosition = 0.5
    }
    
    private func triggerRegulator() {
        self.shouldSpawn = self.regulator.shouldSpawnEntity(boardPosition: self.boardPosition,
                                                            distanceBetweenBarriers: self.distanceBetweenBarriers,
                                                            lastEntityPosition: self.lastEntityPosition)
    }
    
    private func assertShouldSpawn(_ should: Bool) {
        XCTAssert(should == self.shouldSpawn)
    }
    
    private func getNextEntityPosition() {
        self.entityPosition = self.regulator.getSpawnPosition(distanceBetweenBarriers: self.distanceBetweenBarriers,
                                                              lastEntityPosition: self.lastEntityPosition)
    }
    
    private func assertEntityPosition() {
        XCTAssert(self.entityPosition == self.lastEntityPosition + self.distanceBetweenBarriers)
    }
}

class EntityGeneratorTests: XCTestCase {
    
    private var generator = EntityGenerator(random: RealRandom())
    private var entity: EntityType!
    
    func testGenerateEmpty() {
        self.generateEmptyEntity()
        self.assertBlankEntity()
    }
    
    func testGenerateRoundEndThreshold() {
        self.generateRoundEndThresholdEntity()
        self.assertRoundEndThreshold()
    }
    
    func testGenerateChunkEndThreshold() {
        self.generateChunkEndThresholdEntity()
        self.assertChunkEndThreshold()
    }
    
    func testGenerateBarrier() {
        self.generateBarrierEntity()
        self.assertBarrier()
    }
    
    private func generateEmptyEntity() {
        self.entity = self.generator.generateEmpty()
    }
    
    private func generateRoundEndThresholdEntity() {
        self.entity = self.generator.generateRoundEndThreshold()
    }
    
    private func generateChunkEndThresholdEntity() {
        self.entity = self.generator.generateChunkEndThreshold()
    }
    
    private func generateBarrierEntity() {
        self.entity = self.generator.generateBarrier()
    }
    
    private func assertBlankEntity() {
        switch self.entity! {
        case .blank: XCTAssert(true)
        default: XCTAssert(false)
        }
    }
    
    private func assertRoundEndThreshold() {
        switch self.entity! {
        case .threshold(let type): XCTAssert(type == .roundEnd)
        default: XCTAssert(false)
        }
    }
    
    private func assertChunkEndThreshold() {
        switch self.entity! {
        case .threshold(let type): XCTAssert(type == .chunkEnd)
        default: XCTAssert(false)
        }
    }
    
    private func assertBarrier() {
        switch self.entity! {
        case .barrier(let gates): XCTAssert(gates.count == 3)
        default: XCTAssert(false)
        }
    }
}
