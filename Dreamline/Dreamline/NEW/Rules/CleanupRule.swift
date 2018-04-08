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
    
    func process(state: KernelState,
                 events: [KernelEvent],
                 deltaTime: Double) -> ([RuleFlag], [KernelInstruction]) {
        
        var instructions = [KernelInstruction]()
        for entity in state.boardState.entities {
            if isOffBoard(entity: entity, board: state.boardState) {
                instructions.append(.removeEntity(entity.id))
            }
        }
        
        return ([RuleFlag](), instructions)
    }
    
    // MARK: Private Methods
    
    private func isOffBoard(entity: EntityData, board: BoardData) -> Bool {
        let position = entity.position
        let layout = board.layout
        
        let isAboveUpperBound = position > layout.upperBound
        let isBelowLowerBound = position < layout.lowerBound
        return isAboveUpperBound || isBelowLowerBound
    }
}
