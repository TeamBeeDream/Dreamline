//
//  Ruleset.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @NOTE: these are updates caused by updating the model,
// so the name should reflect that (instead of being generic 'event' etc)

// @TODO: rename, the word 'event' is too commonly associated with
// a dynamic delegate system, i'd rather it just be a piece of data
enum Event {
    case barrierAdded(Barrier)
    case barrierDestroyed(Int) // id of barrier
    case barrierPass(Int)
    case barrierHit(Int)
    
    case enteredLane(Lane)
    case exitedLane(Lane)
}

// @TODO: rename
protocol EventListener {
    func playerHitWall()
    func playerPassedThroughGate()
    
    
    // @TODO: implement
    //func roundStart()
    //func roundComplete()
    //func gameOver()
}
