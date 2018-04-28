//
//  CollisionRuleTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class BarrierColliderTests: XCTestCase {
    
    private var collider: BarrierCollider!
    private var gates: [Gate]!
    private var lane: Int!
    private var state: EntityState!
    
    func testPass() {
        self.setupForPass()
        self.getState()
        self.assertState(shouldBe: .passed)
    }
    
    func testCross() {
        self.setupForCross()
        self.getState()
        self.assertState(shouldBe: .crossed)
    }
    
    private func setupForPass() {
        self.collider = BarrierCollider()
        self.gates = [.closed, .open, .closed]
        self.lane = 0
    }
    
    private func setupForCross() {
        self.collider = BarrierCollider()
        self.gates = [.closed, .open, .closed]
        self.lane = -1
    }
    
    private func getState() {
        self.state = self.collider.getEntityStateAfterCollision(gates: self.gates,
                                                                lane: self.lane)
    }
    
    private func assertState(shouldBe newState: EntityState) {
        XCTAssert(self.state == newState)
    }
}
