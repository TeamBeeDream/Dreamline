//
//  GameModel.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

protocol GameModel {
    func addInput(_ lane: Int)
    func removeInput(count: Int)
    func update(dt: Double)
    func getPosition() -> Position
}

class DebugGameModel: GameModel {
    // STATE
    var positioner: Positioner = UserPositioner() // could be interesting to see this being changed at runtime
    var tolerance: Double = 0.1    // @TODO: Set this from config struct
    var moveDuration: Double = 0.1 // @TODO: Set this from config struct
    
    func addInput(_ lane: Int) {
        self.positioner.addInput(lane)
    }
    
    func removeInput(count: Int) {
        self.positioner.removeInput(count: count)
    }
    
    func update(dt: Double) {
        self.positioner.update(dt: dt, moveDuration: self.moveDuration)
    }
    
    func getPosition() -> Position {
        return self.positioner.getPosition(tolerance: self.tolerance)
    }
}
