//
//  FlowControlState.swift
//  Dreamline
//
//  Created by BeeDream on 4/27/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct FlowControlState {
    var phase: FlowControlPhase
}

extension FlowControlState {
    static func new() -> FlowControlState {
        return FlowControlState(phase: .origin)
    }
}

enum FlowControlPhase {
    case origin
    case begin
    case play
    case results
}
