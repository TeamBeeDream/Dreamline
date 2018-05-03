//
//  PositionMutator.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class PositionMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .positionUpdate(let distanceFromOrigin):
            let (nearestLane, distanceFromNearestLane) = calculatePosition(distanceFromOrigin: distanceFromOrigin)
            state.position.distanceFromOrigin = distanceFromOrigin
            state.position.nearestLane = nearestLane
            state.position.distanceFromNearestLane = distanceFromNearestLane
        case .positionTargetUpdate(let target):
            state.position.targetLane = target
        default: break
        }
    }
    
    private func calculatePosition(distanceFromOrigin: Double) -> (nearestLane: Int, distanceFromNearestLane: Double) {
        let nearestLane = round(distanceFromOrigin)
        let distanceFromNearestLane = abs(nearestLane - distanceFromOrigin)
        return (nearestLane: Int(nearestLane), distanceFromNearestLane: distanceFromNearestLane)
    }
}
