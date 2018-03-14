//
//  Ruleset.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: rename, the word 'event' is too commonly associated with
// a dynamic delegate system, i'd rather it just be a piece of data
// maybe 'update'?  'message'?
enum Event {
    case triggerAdded(Trigger)
    case triggerDestroyed(Int)
    
    case barrierPass(Int)
    case barrierHit(Int)
    
    case modifierGet(Int, ModifierType)
    
    case changedLanes
}
