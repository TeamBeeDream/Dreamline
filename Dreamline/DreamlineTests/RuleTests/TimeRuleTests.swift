//
//  TimeRuleTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class TimeCalculatorTests: XCTestCase {
    
    private var calculator: TimeCalculator!
    private var input: TimeCalculator.Bundle!
    private var output: TimeCalculator.Bundle!
    
    func testMoveTimeForward() {
        self.setupTimeCalculator()
        self.calculate()
        self.assertTimeUpdated()
    }
    
    private func setupTimeCalculator() {
        self.calculator = TimeCalculator()
        self.input = (deltaTime: 0.016,
                      frameNumber: 0,
                      timeSinceBeginning: 0.0)
    }
    
    private func calculate() {
        self.output = self.calculator.moveTimeForward(self.input)
    }
    
    private func assertTimeUpdated() {
        XCTAssert(self.output.frameNumber == self.input.frameNumber + 1)
        XCTAssert(self.output.deltaTime == self.input.deltaTime)
        XCTAssert(self.output.timeSinceBeginning == self.input.timeSinceBeginning + self.input.deltaTime)
    }
}

class TimeRuleTests: XCTestCase {
    
    private var timeRule: TimeRule!
    private var state: KernelState!
    private var event: KernelEvent!
    
    private let deltaTime: Double = 0.016
    
    func testProcess() {
        self.setupState()
        self.triggerRule()
        self.assertTimeUpdateEvent()
    }
    
    private func setupState() {
        self.timeRule = TimeRule()
        self.state = KernelState.new()
    }
    
    private func triggerRule() {
        self.event = self.timeRule.process(state: self.state, deltaTime: self.deltaTime)
    }
    
    private func assertTimeUpdateEvent() {
        switch self.event! {
        case .timeUpdate(let deltaTime, let frameNumber, let timeSinceBeginning):
            XCTAssert(deltaTime == self.deltaTime)
            XCTAssert(frameNumber == self.state.time.frameNumber + 1)
            XCTAssert(timeSinceBeginning == self.state.time.timeSinceBeginning + deltaTime)
        default: XCTAssert(false)
        }
    }
}

class TimeRuleIntegrationTests: XCTestCase {
    
    private var originalState: KernelState!
    private var kernel: Kernel!
    private var events: [KernelEvent]!
    
    private let deltaTime: Double = 0.016
    
    func testTimeRuleIntegration() {
        self.setupKernel()
        self.triggerUpdate()
        self.assertEvents()
        self.assertState()
    }
    
    private func setupKernel() {
        let rules = [TimeRule()]
        let mutators = [TimeMutator()]
        self.originalState = KernelState.new()
        self.kernel = KernelImpl(state: self.originalState, rules: rules, mutators: mutators)
    }
    
    private func triggerUpdate() {
        self.events = self.kernel.update(deltaTime: self.deltaTime)
    }
    
    private func assertEvents() {
        switch self.events.first! {
        case .timeUpdate(let deltaTime,
                         let frameNumber,
                         let timeSinceBeginning):
            XCTAssert(deltaTime == self.deltaTime)
            XCTAssert(frameNumber == self.originalState.time.frameNumber + 1)
            XCTAssert(timeSinceBeginning == self.originalState.time.timeSinceBeginning + deltaTime)
        default:
            XCTAssert(false)
        }
    }
    
    private func assertState() {
        let updatedState = self.kernel.getState()
        XCTAssert(updatedState.time.deltaTime == self.deltaTime)
        XCTAssert(updatedState.time.frameNumber == self.originalState.time.frameNumber + 1)
        XCTAssert(updatedState.time.timeSinceBeginning == self.originalState.time.timeSinceBeginning + self.deltaTime)
    }
}
