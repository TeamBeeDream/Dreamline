//
//  TimeRuleTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class TimeRuleTests: XCTestCase {
    
    private var timeRule: TimeRule!
    private var input: TimeRule.Bundle!
    private var output: TimeRule.Bundle!
    
    func testMoveTimeForward() {
        self.setupTimeRule()
        self.triggerRule()
        self.assertTimeUpdated()
    }
    
    private func setupTimeRule() {
        self.timeRule = TimeRule()
        self.input = (deltaTime: 0.016,
                      frameNumber: 0,
                      timeSinceBeginning: 0.0)
    }
    
    private func triggerRule() {
        self.output = self.timeRule.moveTimeForward(self.input)
    }
    
    private func assertTimeUpdated() {
        XCTAssert(self.output.frameNumber == self.input.frameNumber + 1)
        XCTAssert(self.output.deltaTime == self.input.deltaTime)
        XCTAssert(self.output.timeSinceBeginning == self.input.timeSinceBeginning + self.input.deltaTime)
    }
}

class TimeRuleAdapterTests: XCTestCase {
    
    private var timeRuleAdapter: TimeRuleAdapter!
    private var state: KernelState!
    private var event: KernelEvent!
    
    private let deltaTime: Double = 0.016
    
    func testProcess() {
        self.setupState()
        self.triggerRule()
        self.assertTimeUpdateEvent()
    }
    
    private func setupState() {
        self.timeRuleAdapter = TimeRuleAdapter(TimeRule())
        self.state = KernelState.new()
    }
    
    private func triggerRule() {
        self.event = self.timeRuleAdapter.process(state: self.state, deltaTime: self.deltaTime)
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
    
    private var state: KernelState!
    private var kernel: Kernel!
    private var events: [KernelEvent]!
    
    private let deltaTime: Double = 0.016
    
    func testTimeRuleIntegration() {
        self.setupKernel()
        self.triggerUpdate()
        self.assertEvents()
    }
    
    private func setupKernel() {
        let rules = [TimeRuleAdapter(TimeRule())]
        self.state = KernelState.new()
        self.kernel = KernelImpl(state: self.state, rules: rules)
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
            XCTAssert(frameNumber == self.state.time.frameNumber + 1)
            XCTAssert(timeSinceBeginning == self.state.time.timeSinceBeginning + deltaTime)
        }
    }
}
