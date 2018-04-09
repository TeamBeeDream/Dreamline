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
    
    func mutate(state: KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
            case .entityMoved(let id, let position, let layout):
                if isOffBoard(position: position, layout: layout) {
                    instructions.append(.removeEntity(id)) // @BUG
                }
                
            default: break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func isOffBoard(position: Double, layout: BoardLayout) -> Bool {
        let isAboveUpperBound = position > layout.upperBound
        let isBelowLowerBound = position < layout.lowerBound
        return isAboveUpperBound || isBelowLowerBound
    }
}
