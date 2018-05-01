//
//  TimeMutatorTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class TimeMutatorTests: XCTestCase {
    
    private var mutator: TimeMutator!
    private var state: KernelState!
    private var event: KernelEvent!
    
    func testTimeMutator() {
        self.setupStateAndEvent()
        self.mutateState()
        self.assertState()
    }
    
    private func setupStateAndEvent() {
        self.mutator = TimeMutator()
        self.state = KernelState.new()
        self.event = .timeUpdate(deltaTime: 0.16,
                                 frameNumber: 0,
                                 timeSinceBeginning: 0.0)
    }
    
    private func mutateState() {
        var state = self.state!
        self.mutator.mutateState(state: &state, event: self.event)
        self.state = state
    }
    
    private func assertState() {
        switch self.event! {
        case .timeUpdate(let deltaTime,
                         let frameNumber,
                         let timeSinceBeginning):
            XCTAssert(self.state.time.deltaTime == deltaTime)
            XCTAssert(self.state.time.frameNumber == frameNumber)
            XCTAssert(self.state.time.timeSinceBeginning == timeSinceBeginning)
        default: break
        }
    }
}
