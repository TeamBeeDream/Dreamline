//
//  Highscore.swift
//  Dreamline
//
//  Created by BeeDream on 5/3/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class Highscore: NSObject, NSCoding {
    
    // MARK: Public Properties
    var date: String
    var level: Int
    var accuracy: Double
    
    // MARK: Keys
    private static let dateKey = "v1_hs_date"
    private static let levelKey = "v1_hs_level"
    private static let accuracyKey = "v1_hs_accuracy"
    private static let directoryKey = "v1_hs"
    
    init(date: String, level: Int, accuracy: Double) {
        self.date = date
        self.level = level
        self.accuracy = accuracy
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: Highscore.dateKey) as! String
        let level = aDecoder.decodeInteger(forKey: Highscore.levelKey)
        let accuracy = aDecoder.decodeDouble(forKey: Highscore.accuracyKey)
        self.init(date: date, level: level, accuracy: accuracy)
    }
    
    func encode(with aCoder: NSCoder) {
        let date: String = self.date
        let level: Int = self.level
        let accuracy: Double = self.accuracy
        aCoder.encode(date, forKey: Highscore.dateKey)
        aCoder.encode(level, forKey: Highscore.levelKey)
        aCoder.encode(accuracy, forKey: Highscore.accuracyKey)
    }
    
    private func getUrl() -> URL {
        let directory = FileManager().urls(for: .documentDirectory,
                                           in: .userDomainMask).first!
        return directory.appendingPathComponent(Highscore.directoryKey)
    }
}
