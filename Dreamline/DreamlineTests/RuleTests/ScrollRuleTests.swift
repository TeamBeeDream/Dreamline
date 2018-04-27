//
//  ScrollRuleTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class ScrollRuleTests: XCTestCase {
    
    private var scrollRule: ScrollRule!
    private var scrollDistance: Double!
    
    private var deltaTime: Double!
    private var paused: Bool!
    private var scrollSpeed: Double!
    
    func testScrollRulePaused() {
        self.setupRule(paused: true)
        self.triggerRule()
        self.assertScrollDistance()
    }
    
    func testScrollRuleUnpaused() {
        self.setupRule(paused: false)
        self.triggerRule()
        self.assertScrollDistance()
    }
    
    private func setupRule(paused: Bool) {
        self.scrollRule = ScrollRule()
        self.deltaTime = 0.016
        self.paused = paused
        self.scrollSpeed = 1.0
    }
    
    private func triggerRule() {
        self.scrollDistance = self.scrollRule.calculateScrollDistance(deltaTime: self.deltaTime,
                                                                      paused: self.paused,
                                                                      scrollSpeed: self.scrollSpeed)
    }
    
    private func assertScrollDistance() {
        if self.paused {
            XCTAssert(self.scrollDistance == 0.0)
        } else {
            XCTAssert(self.scrollDistance == self.scrollSpeed * self.deltaTime)
        }
    }
}

class ScrollRuleAdapterTests: XCTestCase {
    
    private var scrollRuleAdapter: ScrollRuleAdapter!
    private var state: KernelState!
    private var event: KernelEvent!
    
    private let deltaTime: Double = 0.016
    private let scrollSpeed: Double = 1.0
    
    func testScrollRuleAdapter() {
        self.setupRuleAdapter()
        self.triggerRule()
        self.assertEvent()
    }
    
    private func setupRuleAdapter() {
        self.scrollRuleAdapter = ScrollRuleAdapter()
        self.state = KernelState.new()
        self.state.board.scrollSpeed = self.scrollSpeed
    }
    
    private func triggerRule() {
        self.event = self.scrollRuleAdapter.process(state: self.state, deltaTime: self.deltaTime)
    }
    
    private func assertEvent() {
        switch self.event! {
        case .boardScroll(let distance):
            XCTAssert(distance == self.scrollSpeed * self.deltaTime)
        default: break
        }
    }
}

class ScrollRuleIntegrationTests: XCTestCase {
    
    private var originalState: KernelState!
    private var kernel: Kernel!
    private var events: [KernelEvent]!
    
    private let deltaTime: Double = 0.016
    private let scrollSpeed: Double = 1.0
    
    func testScrollRuleIntegration() {
        self.setupKernel()
        self.triggerUpdate()
        self.assertState()
        self.assertEvents()
    }
    
    private func setupKernel() {
        let rules = [ScrollRuleAdapter()]
        let mutators = [BoardMutator()]
        self.originalState = KernelState.new()
        self.originalState.board.scrollSpeed = scrollSpeed
        self.kernel = KernelImpl(state: self.originalState, rules: rules, mutators: mutators)
    }
    
    private func triggerUpdate() {
        self.events = self.kernel.update(deltaTime: self.deltaTime)
    }
    
    private func assertState() {
        let updatedState = self.kernel.getState()
        XCTAssert(updatedState.board.position == self.originalState.board.position + (self.deltaTime * self.scrollSpeed))
    }
    
    private func assertEvents() {
        switch self.events.first! {
        case .boardScroll(let distance):
            XCTAssert(distance == self.deltaTime * self.scrollSpeed)
        default: break
        }
    }
}
