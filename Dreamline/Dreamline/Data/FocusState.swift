//
//  Focus.swift
//  Dreamline
//
//  Created by BeeDream on 4/3/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct FocusState {
    var level: Int // @NOTE: Should this be 1 based or 0 based?
    var delay: Double
}

extension FocusState {
    func clone() -> FocusState {
        return FocusState(level: self.level,
                          delay: self.delay)
    }
}

class FocusStateFactory {
    static func getDefault() -> FocusState {
        return FocusState(level: 3, delay: 0.0) // @FIXME: Might need config
    }
}
