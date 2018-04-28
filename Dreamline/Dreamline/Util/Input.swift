//
//  Input.swift
//  Dreamline
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class Input {
    
    private var current: Int = 0
    private var inputCount: Int = 0
    
    func addInput(target: Int) {
        self.current = target
        self.inputCount += 1
    }
    
    func removeInput(count: Int = 1) {
        self.inputCount -= count
        if self.inputCount == 0 {
            self.reset()
        }
    }
    
    func getCurrent() -> Int {
        return self.current
    }
    
    func reset() {
        self.current = 0
        self.inputCount = 0
    }
}
