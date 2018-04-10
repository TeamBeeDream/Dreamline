//
//  BoardKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @NOTE: Should entities be in the board state
// or should they have their own state/kernel?
class BoardKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> BoardKernel {
        let instance = BoardKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instr: KernelInstruction) {
        
        switch instr {
        
        case .addEntity(let data):
            state.boardState.entities[data.id] = data
            events.append(.entityAdded(data))
        
        case .removeEntity(let id):
            state.boardState.entities[id] = nil
            events.append(.entityRemoved(id))
            
        // @CLEANUP
        case .scrollBoard(let distance):
            for id in state.boardState.entities.keys {
                let prevPos = state.boardState.entities[id]!.position
                state.boardState.entities[id]!.position += distance
                events.append(.entityMoved(state.boardState.entities[id]!,
                                           prevPos))
            }
            state.boardState.scrollDistance += distance
            events.append(.boardScrolled(state.boardState.scrollDistance, distance))

        case .updateEntityState(let id, let entityState):
            state.boardState.entities[id]!.state = entityState
            events.append(.entityStateChanged(state.boardState.entities[id]!))
            
        default: break
            
        }
    }
}
















