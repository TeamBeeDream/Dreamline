//
//  Position.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct PositionData {
    var offset: Double
    var velocity: Double
    var nearestLane: Int
    var distanceFromNearestLane: Double
    
    static func new() -> PositionData {
        return PositionData(offset: 0.0,
                            velocity: 0.0,
                            nearestLane: 0,
                            distanceFromNearestLane: 0.0)
    }
    
    static func clone(_ data: PositionData) -> PositionData {
        return PositionData(offset: data.offset,
                            velocity: data.velocity,
                            nearestLane: data.nearestLane,
                            distanceFromNearestLane: data.distanceFromNearestLane)
    }
}
