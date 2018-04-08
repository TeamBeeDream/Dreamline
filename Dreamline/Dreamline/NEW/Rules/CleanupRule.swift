//
//  CleanupRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class CleanupRule: Rule {
    
    // MARK: Init
    
    static func make() -> CleanupRule {
        return CleanupRule()
    }
    
    // MARK: Rule Methods
    
    /*func process(state: KernelState,
                 events: [KernelEvent],
                 deltaTime: Double) -> ([RuleFlag], [KernelInstruction]) {
        
        var instructions = [KernelInstruction]()
        for entity in state.boardState.entities {
            if isOffBoard(entity: entity, layout: state.boardState.layout) {
                instructions.append(.removeEntity(entity.id))
            }
        }
        
        return ([RuleFlag](), instructions)
    }*/
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        for entity in state.boardState.entities {
            if isOffBoard(entity: entity, layout: state.boardState.layout) {
                instructions.append(.removeEntity(entity.id))
            }
        }
    }
    
    // MARK: Private Methods
    
    private func isOffBoard(entity: EntityData, layout: BoardLayout) -> Bool {
        let position = entity.position
        
        let isAboveUpperBound = position > layout.upperBound
        let isBelowLowerBound = position < layout.lowerBound
        return isAboveUpperBound || isBelowLowerBound
    }
}
