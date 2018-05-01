//
//  BoardMutatorTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class BoardMutatorTests: XCTestCase {
    
    private var mutator: BoardMutator!
    private var state: KernelState!
    private var event: KernelEvent!
    
    func testBoardMutator_BoardScrollEvent() {
        self.setupStateAndEvent()
        self.triggerMutation()
        self.assertState()
    }
    
    private func setupStateAndEvent() {
        self.mutator = BoardMutator()
        self.state = KernelState.new()
        self.event = .boardScroll(distance: 1.0)
    }
    
    private func triggerMutation() {
        var state = self.state!
        self.mutator.mutateState(state: &state, event: self.event)
        self.state = state
    }
    
    private func assertState() {
        switch self.event! {
        case .boardScroll(let distance):
            XCTAssert(distance == self.state.board.position)
        default: break
        }
    }
}
