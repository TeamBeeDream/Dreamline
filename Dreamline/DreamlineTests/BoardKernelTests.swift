//
//  BoardKernel.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class BoardKernelTests: XCTestCase {
    
    // MARK: Test Properties
    
    private var kernel: BoardKernel!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        self.kernel = BoardKernel.make()
    }
    
    // MARK: Tests
    
    func testBoardKernel_addEntity() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let entity = self.getMockEntity()
        let instruction = KernelInstruction.addEntity(entity)
        
        XCTAssert(state.boardState.entities.count == 0)
        self.kernel.update(state: &state, events: &events, instr: instruction)
        XCTAssert(state.boardState.entities.count == 1)
        XCTAssert(state.boardState.entities[0] == entity)
    }
    
    func testBoardKernel_removeEntity() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let entity = self.getMockEntity()
        
        self.kernel.update(state: &state, events: &events, instr: .addEntity(entity))
        XCTAssert(state.boardState.entities.count == 1)
        self.kernel.update(state: &state, events: &events, instr: .removeEntity(entity.id))
        XCTAssert(state.boardState.entities.count == 0)
    }
    
    func testBoardKernel_scrollBoard() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let entity = self.getMockEntity()
        let distance = RealRandom().next()
        
        self.kernel.update(state: &state, events: &events, instr: .addEntity(entity))
        XCTAssert(state.boardState.entities[0]!.position == 0.0)
        self.kernel.update(state: &state, events: &events, instr: .scrollBoard(distance))
        XCTAssert(state.boardState.entities[0]!.position == distance)
    }
    
    func testBoardKernel_updateEntityState() {
        var state = KernelState.new()
        var events = [KernelEvent]()
        
        let entity = self.getMockEntity()
        
        self.kernel.update(state: &state, events: &events, instr: .addEntity(entity))
        XCTAssert(state.boardState.entities[0]!.state == .none)
        self.kernel.update(state: &state, events: &events, instr: .updateEntityState(entity.id, .hit))
        XCTAssert(state.boardState.entities[0]!.state == .hit)
    }
    
    // MARK: Private Methods
    
    private func getMockEntity() -> Entity {
        return Entity(id: 0,
                      position: 0.0,
                      state: .none,
                      type: .none,
                      data: .none)
    }
}
