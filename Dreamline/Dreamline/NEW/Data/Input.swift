//
//  Input.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct InputData {
    var targetLane: Int
    
    static func new() -> InputData {
        return InputData(targetLane: 0)
    }
    
    static func clone(_ data: InputData) -> InputData {
        return InputData(targetLane: data.targetLane)
    }
}
