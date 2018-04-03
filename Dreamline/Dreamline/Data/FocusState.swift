//
//  Focus.swift
//  Dreamline
//
//  Created by BeeDream on 4/3/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct FocusState {
    var max: Int
    var current: Int
    // @NOTE: Should probably do some sort of data validity check
    // to make sure current never leaves the range [1, max]
    // @NOTE: Should this be 1 based or 0 based?
    
    // @TODO: Handle timing
}

extension FocusState {
    func clone() -> FocusState {
        return FocusState(max: self.max, current: self.current)
    }
    
    func isMax() -> Bool {
        return self.current == self.max
    }
    
    func isMin() -> Bool {
        return self.current <= 1
    }
}

class FocusStateFactory {
    static func getDefault() -> FocusState {
        return FocusState(max: 3, current: 1)
    }
}
