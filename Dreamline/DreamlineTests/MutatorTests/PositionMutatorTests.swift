//
//  PositionMutatorTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class PositionMutatorTests: XCTestCase {
    
    private var mutator: PositionMutator!
    private var state: KernelState!
    private var event: KernelEvent!
    private var newPosition: Double!
    private var target: Int!
    
    func testCenterLane() {
        self.setupEvent(position: 0.0)
        self.mutateState()
        self.assertNewPosition()
    }
    
    func testLeftLane() {
        self.setupEvent(position: -1.0)
        self.mutateState()
        self.assertNewPosition()
    }
    
    func testRightLane() {
        self.setupEvent(position: 1.0)
        self.mutateState()
        self.assertNewPosition()
    }
    
    func testMidLeftLane() {
        self.setupEvent(position: -0.5)
        self.mutateState()
        self.assertNewPosition()
    }
    
    func testMidRightLane() {
        self.setupEvent(position: 0.5)
        self.mutateState()
        self.assertNewPosition()
    }
    
    func testTargetUpdate() {
        self.setupEvent(target: 1)
        self.mutateState()
        self.assertNewTarget()
    }
    
    private func setupEvent(position: Double) {
        self.mutator = PositionMutator()
        self.state = KernelState.new()
        self.event = .positionUpdate(distanceFromOrigin: position)
        self.newPosition = position
    }
    
    private func setupEvent(target: Int) {
        self.mutator = PositionMutator()
        self.state = KernelState.new()
        self.event = .positionTargetUpdate(target: target)
        self.target = target
    }
    
    private func mutateState() {
        var state = self.state!
        mutator.mutateState(state: &state, event: self.event)
        self.state = state
    }
    
    private func assertNewPosition() {
        XCTAssert(self.state.position.distanceFromOrigin == self.newPosition)
        XCTAssert(self.state.position.nearestLane == Int(round(self.newPosition)))
        XCTAssert(self.state.position.distanceFromNearestLane ==
            abs(round(self.newPosition) - self.newPosition))
    }
    
    private func assertNewTarget() {
        XCTAssert(self.state.position.targetLane == self.target)
    }
}
