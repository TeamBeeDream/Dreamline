//
//  Highscore.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class Highscore: NSObject, NSCoding {
    
    var name: String
    var score: Int
    
    static func getDefault() -> Highscore {
        
        let highscore = Highscore(name: "AAA", score: 0)
        return highscore
    }
    
    struct PropertyKey {
        static let name = "hsName"
        static let score = "hsScore"
    }
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("highscores")
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String // @HARDCODED
        let score = aDecoder.decodeInteger(forKey: PropertyKey.score)
        
        self.init(name: name, score: score)
    }
    
    func encode(with aCoder: NSCoder) {
        
        let name: String = self.name
        aCoder.encode(name, forKey: PropertyKey.name)
        let score: Int = self.score
        aCoder.encode(score, forKey: PropertyKey.score)
    }
    
    static func generateRandomName() -> String {
        let letters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var result = ""
        
        for _ in 1...3 {
            let rand = arc4random_uniform(UInt32(letters.length))
            var nextChar = letters.character(at: Int(rand))
            result += NSString(characters: &nextChar, length: 1) as String
        }
        
        return result
    }
}
