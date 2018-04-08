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
    
    static func make(scrollSpeed: Double) -> ScrollRule {
        let instance = ScrollRule()
        instance.scrollSpeed = scrollSpeed
        return instance
    }
    
    // MARK: Rule Methods
    
    func mutate(state: inout KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        for event in events {
            switch event {
                
            case .tick(let dt):
                instructions.append(.scrollBoard(self.scrollSpeed * dt))
                
            default: break
                
            }
        }
    }
}