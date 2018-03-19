//
//  Highscore.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @TODO: This whole class needs to be refactored
class Highscore: NSObject, NSCoding {
    
    var score: Int
    
    static func getDefault() -> Highscore {
        return Highscore(score: 0)
    }
    
    // @HARDCODED
    struct PropertyKey {
        static let score = "hsScore"
    }
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("highscores") // @HARDCODED
    
    init(score: Int) {
        self.score = score
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        self.init(score: score)
    }
    
    func encode(with aCoder: NSCoder) {
        let score: Int = self.score
        aCoder.encode(score, forKey: PropertyKey.score)
    }
}
