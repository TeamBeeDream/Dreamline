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
    func process(state: KernelState, deltaTime: Double) -> KernelEvent? {
        for entity in state.board.entities {
            if Collision.didCrossLine(testPosition: state.board.layout.playerPosition,
                                      linePosition: entity.position,
                                      lineDelta: state.board.scrollSpeed * deltaTime) {
                let events = self.getEventsFromDelegates(state: state,
                                                         entity: entity,
                                                         lane: state.position.nearestLane)
                if !events.isEmpty { return .multiple(events: events) }
            }
        }
        return nil
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
        switch entity.type {
        case .barrier(let gates):
            if !state.health.invincible {
                var events = [KernelEvent]()
                
                let entityState = self.getEntityStateAfterCollision(gates: gates, lane: lane)
                events.append(.boardEntityStateUpdate(id: entity.id, state: entityState))
                
                if entityState == .crossed {
                    events.append(.healthHitPointUpdate(increment: -1))
                    events.append(.healthInvincibleUpdate(invincible: true))
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
                var events = [KernelEvent]()
                
                events.append(.boardEntityStateUpdate(id: entity.id, state: .crossed))
                
                if state.health.invincible {
                    events.append(.healthInvincibleUpdate(invincible: false))
                } else {
                    events.append(.chunkNext)
                }
                
                return events
            case .roundEnd:
                return [
                    .boardEntityStateUpdate(id: entity.id, state: .crossed),
                    .flowControlPhaseUpdate(phase: .results)]
            }
        default:
            return []
        }
    }
}
