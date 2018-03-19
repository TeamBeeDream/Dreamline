//
//  Score.swift
//  Dreamline
//
//  Created by BeeDream on 3/19/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct Score {
    var points: Int
}

extension Score {
    func clone() -> Score {
        return Score(points: self.points)
    }
}

class ScoreFactory {
    static func getNew() -> Score {
        return Score(points: 0)
    }
}
