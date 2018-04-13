//
//  TimeKernelTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class TimeKernelTests: XCTestCase {
    
    // MARK: Test Properties
    
    private var kernel: TimeKernel!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        self.kernel = TimeKernel.make()
    }
    
    // MARK: Tests
    
    func testTimeKernel_timeSinceBeginning() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let delta = RealRandom().next()
        let instruction = KernelInstruction.tick(delta)
        
        XCTAssert(state.timeState.timeSinceBeginning == 0.0)
        self.kernel.update(state: &state, events: &events, instr: instruction)
        XCTAssert(state.timeState.timeSinceBeginning == delta)
    }
    
    func testTimeKernel_deltaTime() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let delta = self.getRandomTimeDelta()
        let instruction = KernelInstruction.tick(delta)
        
        XCTAssert(state.timeState.deltaTime == 0.0)
        self.kernel.update(state: &state, events: &events, instr: instruction)
        XCTAssert(state.timeState.deltaTime == delta)
    }
    
    func testTimeKernel_frameNumber() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let delta = self.getRandomTimeDelta()
        let instruction = KernelInstruction.tick(delta)
        
        XCTAssert(state.timeState.frameNumber == 0)
        self.kernel.update(state: &state, events: &events, instr: instruction)
        XCTAssert(state.timeState.deltaTime == delta)
    }
    
    func testTimeKernel_pause() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        XCTAssert(state.timeState.paused == false)
        self.kernel.update(state: &state, events: &events, instr: .pause)
        XCTAssert(state.timeState.paused == true)
        self.kernel.update(state: &state, events: &events, instr: .unpause)
        XCTAssert(state.timeState.paused == false)
    }
    
    // MARK: Private Methods
    
    private func getRandomTimeDelta() -> Double {
        return RealRandom().next()
    }
}
