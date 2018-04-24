//
//  Score.swift
//  Dreamline
//
//  Created by BeeDream on 4/23/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct ScoreData {
    var barriersPassed: Int
    
    static func new() -> ScoreData {
        return ScoreData(barriersPassed: 0)
    }
}
