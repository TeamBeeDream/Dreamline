//
//  PositionKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class PositionKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> PositionKernel {
        let instance = PositionKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    func update(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        switch instr {
            
        case .updatePositionOffset(let offset):
            let (velocity, nearestLane, distance) = self.calcPosition(offset: offset,
                                                                      prevOffset: state.positionState.offset)
            state.positionState.offset = offset
            state.positionState.velocity = velocity
            state.positionState.nearestLane = nearestLane
            state.positionState.distanceFromNearestLane = distance
            
            events.append(.positionUpdated(state.positionState))
            
        default: break
            
        }
    }
    
    // MARK: Private Methods
    
    // @NOTE: Could make this a class to test that it's doing the right thing,
    // would avoid having to send a simulated event to test the kernel
    private func calcPosition(offset: Double, prevOffset: Double) -> (Double, Int, Double) {
        let velocity = offset - prevOffset
        let nearestLane = round(offset)
        let distance = offset - nearestLane // @TEST
        
        return (velocity, Int(nearestLane), distance)
    }
}
