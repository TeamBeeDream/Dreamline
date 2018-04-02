//
//  Ruleset.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @RENAME: 'Event' feels to generic
//          This data represents a change in state
enum Event {
    case roundBegin
    case roundEnd
    
    case entityAdd(Entity)
    case entityDestroy(Int)
    
    case barrierPass(Int)
    case barrierHit(Int)
    
    case modifierGet(Int, ModifierType)
    
    case thresholdCross
    
    case laneChange
}

// @RENAME: This is an event that is handled by the top-level VC
enum SceneEvent {
    case next       // advance to next scene
    case back       // revert to previous scene
}
