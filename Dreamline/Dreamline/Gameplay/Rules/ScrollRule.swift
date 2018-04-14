//
//  ScrollProtocol.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class ScrollRule: Rule {
    
    // MARK: Public Properties
    
    var scrollSpeed: Double!
    
    // MARK: Init
    
    static func make() -> ScrollRule {
        let instance = ScrollRule()
        return instance
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {
        self.scrollSpeed = state.speedState.speed
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        for event in events {
            switch event {
                
            case .speedUpdated(let speed):
                self.scrollSpeed = speed
                
            case .tick(let dt):
                instructions.append(.scrollBoard(self.scrollSpeed * dt))
                
            default: break
                
            }
        }
    }
}
