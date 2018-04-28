//
//  LineCollisionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class CollisionRule: Rule {
    
    private let barrierCollider = BarrierCollider()
    
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        for entity in state.board.entities {
            if Collision.didCrossLine(testPosition: state.board.layout.playerPosition,
                                      linePosition: entity.position,
                                      lineDelta: state.board.scrollSpeed * deltaTime) {
                let state = self.determineEntityState(type: entity.type, lane: state.position.nearestLane)
                return .boardEntityStateUpdate(id: entity.id, state: state)
            }
        }
        return nil
    }
    
    private func determineEntityState(type: EntityType, lane: Int) -> EntityState {
        switch type {
        case .blank:
            return .none
        case .barrier(let gates):
            return self.barrierCollider.getEntityStateAfterCollision(gates: gates,
                                                                     lane: lane)
        case .threshold(_):
            return .crossed
        }
    }
}

class BarrierCollider {
    func getEntityStateAfterCollision(gates: [Gate], lane: Int) -> EntityState {
        let laneIndex = lane + 1
        switch gates[laneIndex] {
        case .open: return .passed
        case .closed: return .crossed
        }
    }
}
