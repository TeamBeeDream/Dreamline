//
//  BoardKernel.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class BoardKernel: Kernel {
    
    // MARK: Init
    
    static func make() -> BoardKernel {
        let instance = BoardKernel()
        return instance
    }
    
    // MARK: Kernel Methods
    
    /*func update(state: KernelState,
                instructions: [KernelInstruction]) -> (KernelState, [KernelEvent]) {
        
        var boardState = BoardData.clone(state.boardState)
        var raisedEvents = [KernelEvent]()
        for instr in instructions {
            switch instr {
            case .addEntity(let data):
                boardState.entities.append(data)
                raisedEvents.append(.barrierAdded(data))
                
            case .removeEntity(let id):
                boardState.entities = boardState.entities.filter { $0.id != id }
                raisedEvents.append(.barrierRemoved(id))
                
            case .scrollBoard(let distance):
                boardState.entities = boardState.entities.map({
                    EntityData(id: $0.id,
                               position: $0.position + distance,
                               type: $0.type)
                })
                boardState.scrollDistance += distance
                raisedEvents.append(.boardScrolled(distance))
                
            default: break
                
            }
        }
        
        var updatedState = KernelState.clone(state)
        updatedState.boardState = boardState
        
        // @TEMP
        return (updatedState, raisedEvents)
    }*/
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: [KernelInstruction]) {
        
        for instr in instructions {
            switch instr {
            
            case .addEntity(let data):
                state.boardState.entities.append(data)
                events.append(.barrierAdded(data))
            
            case .removeEntity(let id):
                // @PERFORMANCE
                state.boardState.entities = state.boardState.entities.filter { $0.id != id }
                events.append(.barrierRemoved(id))
                
            case .scrollBoard(let distance):
                // This sucks
                state.boardState.entities = state.boardState.entities.map({
                    EntityData(id: $0.id,
                               position: $0.position + distance,
                               type: $0.type)
                })
                state.boardState.scrollDistance += distance
                events.append(.boardScrolled(distance))
                
            default: break
                
            }
        }
    }
}
















