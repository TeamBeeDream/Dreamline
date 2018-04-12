//
//  PositionKernelTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class PositionKernelTests: XCTestCase {
    
    // MARK: Test Properties
    
    private var kernel: PositionKernel!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        self.kernel = PositionKernel.make()
    }
    
    // MARK: Tests
    
    func testPositionKernel_offset() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let offset = RealRandom().next()
        
        XCTAssert(state.positionState.offset == 0.0)
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(offset))
        XCTAssert(state.positionState.offset == offset)
    }
    
    func testPositionKernel_velocity() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let offset = RealRandom().next()
        
        XCTAssert(state.positionState.velocity == 0.0)
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(offset))
        XCTAssert(state.positionState.velocity == offset)
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(0.0))
        XCTAssert(state.positionState.velocity == -offset)
    }
    
    func testPositionKernel_nearestLane() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let leftLane = -1.0
        let rightLane = 1.0
        
        XCTAssert(state.positionState.nearestLane == 0)
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(leftLane))
        XCTAssert(state.positionState.nearestLane == Int(leftLane))
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(rightLane))
        XCTAssert(state.positionState.nearestLane == Int(rightLane))
    }
    
    func testPositionKernel_distanceFromNearestLane() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        XCTAssert(state.positionState.distanceFromNearestLane == 0.0)
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(0.25))
        XCTAssert(state.positionState.distanceFromNearestLane == 0.25)
        self.kernel.mutate(state: &state, events: &events, instr: .updatePositionOffset(0.75))
        XCTAssert(state.positionState.distanceFromNearestLane == -0.25)
    }
}
