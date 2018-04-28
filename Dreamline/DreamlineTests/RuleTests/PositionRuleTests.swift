//
//  PositionTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class PositionRuleTests: XCTestCase {
    
    private var rule: PositionRule!
    private var state: KernelState!
    private var event: KernelEvent!
    private var target: Double!
    
    func testMoveLeft() {
        self.setupState(lane: 0, target: -1)
        self.triggerRule()
        self.assertEvent()
    }
    
    func testMoveRight() {
        self.setupState(lane: 0, target: 1)
        self.triggerRule()
        self.assertEvent()
    }
    
    func testDontMove() {
        self.setupState(lane: 0, target: 0)
        self.triggerRule()
        self.assertEvent()
    }
    
    func testReturnToCenter() {
        self.setupState(lane: 1, target: 0)
        self.triggerRule()
        self.assertEvent()
    }
    
    private func setupState(lane: Int, target: Int) {
        self.rule = PositionRule()
        self.state = KernelState.new()
        self.state.position.distanceFromOrigin = Double(lane)
        self.state.position.targetLane = target
        self.target = Double(target)
    }
    
    private func triggerRule() {
        let deltaTime = PositionRule.MOVE_DURATION
        self.event = self.rule.process(state: self.state,
                                       deltaTime: deltaTime)
    }
    
    private func assertEvent() {
        switch self.event! {
        case .positionUpdate(let distanceFromOrigin):
            XCTAssert(distanceFromOrigin == self.target)
        default:
            XCTAssert(false)
        }
    }
}

class PositionCalculatorTests: XCTestCase {
    
    private var calculator: PositionCalculator!
    private var state: PositionState!
    private var target: Double!
    private var position: Double!
    
    func testMoveLeft() {
        self.setupState(lane: 0, target: -1)
        self.calculate()
        self.assertNewPosition()
    }
    
    func testMoveRight() {
        self.setupState(lane: 0, target: 1)
        self.calculate()
        self.assertNewPosition()
    }
    
    func testDontMove() {
        self.setupState(lane: 0, target: 0)
        self.calculate()
        self.assertNewPosition()
    }
    
    func testReturnToCenter() {
        self.setupState(lane: 1, target: 0)
        self.calculate()
        self.assertNewPosition()
    }
    
    private func setupState(lane: Int, target: Int) {
        self.calculator = PositionCalculator()
        self.state = PositionState.new()
        self.state.distanceFromOrigin = Double(lane)
        self.state.targetLane = target
        self.target = Double(target)
    }
    
    private func calculate() {
        let deltaTime = PositionRule.MOVE_DURATION
        self.position = self.calculator.calculateNewPosition(deltaTime: deltaTime,
                                                             moveDuration: deltaTime,
                                                             originalState: self.state)
    }
    
    private func assertNewPosition() {
        XCTAssert(self.position == self.target)
    }
}
