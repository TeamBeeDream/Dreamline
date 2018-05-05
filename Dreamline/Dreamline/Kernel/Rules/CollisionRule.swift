//
//  LineCollisionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class CollisionRule: Rule {
    
    // @TODO: Pass in multiple delegates
    private var delegates: [CollisionDelegate]!
    
    init() { // @HARDCODED
        self.delegates = [BarrierCollisionDelegate(),
                          ThresholdCollisionDelegate()]
    }
    
    // @TODO: Bundle a KernelEvent with multiple events
    func process(state: KernelState, deltaTime: Double) -> [KernelEvent] {
        for entity in state.board.entities {
            if Collision.didCrossLine(testPosition: state.board.layout.playerPosition,
                                      linePosition: entity.position,
                                      lineDelta: state.board.scrollSpeed * deltaTime * 2) {
                let events = self.getEventsFromDelegates(state: state,
                                                         entity: entity,
                                                         lane: state.position.nearestLane)
                if !events.isEmpty { return events }
            }
        }
        return []
    }
    
    private func getEventsFromDelegates(state: KernelState, entity: Entity, lane: Int) -> [KernelEvent] {
        var events = [KernelEvent]()
        for delegate in self.delegates {
            let delegateEvents = delegate.didCollide(state: state, entity: entity, lane: lane)
            events.append(contentsOf: delegateEvents)
        }
        return events
    }
}

protocol CollisionDelegate {
    func didCollide(state: KernelState, entity: Entity, lane: Int) -> [KernelEvent]
}

class BarrierCollisionDelegate: CollisionDelegate {
    func didCollide(state: KernelState, entity: Entity, lane: Int) -> [KernelEvent] {
        if entity.state != .none { return [] }
        switch entity.type {
        case .barrier(let gates):
            if !state.health.invincible {
                var events = [KernelEvent]()
                
                let entityState = self.getEntityStateAfterCollision(gates: gates, lane: lane)
                events.append(.boardEntityStateUpdate(id: entity.id,
                                                      type: entity.type,
                                                      state: entityState))
                
                if entityState == .crossed {
                    events.append(.healthHitPointUpdate(increment: -1))
                    events.append(.healthInvincibleUpdate(invincible: true))
                    events.append(.healthBarrierUpdate(pass: false))
                } else {
                    events.append(.healthBarrierUpdate(pass: true))
                }
                
                return events
            } else {
                return []
            }
            
        default:
            return []
        }
    }
    
    private func getEntityStateAfterCollision(gates: [Gate], lane: Int) -> EntityState {
        let laneIndex = lane + 1
        switch gates[laneIndex] {
        case .open: return .passed
        case .closed: return .crossed
        }
    }
}

class ThresholdCollisionDelegate: CollisionDelegate {
    
    func didCollide(state: KernelState, entity: Entity, lane: Int) -> [KernelEvent] {
        switch entity.type {
        case .threshold(let type):
            if entity.state != .none { return [] } // @HACK
            switch type {
            case .chunkEnd:
                if state.health.invincible { return [] }
                return [.boardEntityStateUpdate(id: entity.id,
                                                type: entity.type,
                                                state: .crossed),
                        .chunkNext,
                .healthInvincibleUpdate(invincible: false)]
            case .roundEnd:
                return [
                .boardEntityStateUpdate(id: entity.id,
                                        type: entity.type,
                                        state: .crossed),
                    .flowControlPhaseUpdate(phase: .results),
                .healthInvincibleUpdate(invincible: false)]
            case .recovery:
                return [
                    .boardEntityStateUpdate(id: entity.id,
                                            type: entity.type,
                                            state: .crossed),
                        .healthInvincibleUpdate(invincible: false)]
            }
        default:
            return []
        }
    }
}
