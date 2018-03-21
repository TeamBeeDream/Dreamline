//
//  Highscore.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @NOTE: This is a temporary class for storing highscores
//        on the user's local device storage
class Highscore: NSObject, NSCoding {
    
    var score: Int
    static let scoreKey = "hsScore" // @HARDCODED
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory,
                                                       in: .userDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("highscores") // @HARDCODED
    
    init(score: Int) {
        self.score = score
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeInteger(forKey: Highscore.scoreKey)
        self.init(score: score)
    }
    
    func encode(with aCoder: NSCoder) {
        let score: Int = self.score // @NOTE: For some reason, you need to do this before
                                    //        encoding, otherwise the data is corrupted
        aCoder.encode(score, forKey: Highscore.scoreKey)
    }
}
