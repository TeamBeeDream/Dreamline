//
//  Definitions.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol Kernel {
    func update(deltaTime: Double) -> [KernelEvent]
    func getState() -> KernelState
    func addEvent(event: KernelEvent)
}

protocol Rule {
    func process(state: KernelState, deltaTime: Double) -> KernelEvent?
}

protocol Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent)
}

protocol Observer {
    func observe(event: KernelEvent)
}

enum KernelEvent {
    case timeUpdate(deltaTime: Double,
                    frameNumber: Int,
                    timeSinceBeginning: Double)
    case timePauseUpdate(pause: Bool)
    case boardScroll(distance: Double)
    case boardEntityAdd(entity: Entity)
    case boardEntityRemove(id: Int)
    case boardEntityStateUpdate(id: Int, type: EntityType, state: EntityState)
    case boardScrollSpeedUpdate(speed: Double)
    case boardReset
    case positionUpdate(distanceFromOrigin: Double)
    case positionTargetUpdate(target: Int)
    case healthHitPointSet(Int)
    case healthHitPointUpdate(increment: Int)
    case healthInvincibleUpdate(invincible: Bool)
    case flowControlPhaseUpdate(phase: FlowControlPhase)
    case chunkNext
    case chunkSet(chunks: [Chunk])
    case chunkLevelUpdate(level: Int)
    case settingsMuteUpdate(mute: Bool)
    
    case multiple(events: [KernelEvent]) // :(
}
