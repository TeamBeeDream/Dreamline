//
//  CleanupRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class CleanupRule: Rule {
    
    // MARK: Private Properties
    
    private var layout: BoardLayout!
    
    // MARK: Init
    
    static func make() -> CleanupRule {
        return CleanupRule()
    }
    
    // MARK: Rule Methods
    
    func setup(state: KernelState) {
        self.layout = state.boardState.layout
    }
    
    func mutate(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
            case .entityMoved(let entity, _):
                if isOffBoard(position: entity.position, layout: self.layout) {
                    instructions.append(.removeEntity(entity.id))
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
