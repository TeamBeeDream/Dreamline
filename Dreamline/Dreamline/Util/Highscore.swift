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
    var points: Int
    
    // MARK: Keys
    private static let dateKey = "v2_hs_date"
    private static let levelKey = "v2_hs_level"
    private static let pointsKey = "v2_hs_points"
    private static let directoryKey = "v2_hs"
    
    init(date: String, level: Int, points: Int) {
        self.date = date
        self.level = level
        self.points = points
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: Highscore.dateKey) as! String
        let level = aDecoder.decodeInteger(forKey: Highscore.levelKey)
        let points = aDecoder.decodeInteger(forKey: Highscore.pointsKey)
        self.init(date: date, level: level, points: points)
    }
    
    func encode(with aCoder: NSCoder) {
        let date: String = self.date
        let level: Int = self.level
        let points: Int = self.points
        aCoder.encode(date, forKey: Highscore.dateKey)
        aCoder.encode(level, forKey: Highscore.levelKey)
        aCoder.encode(points, forKey: Highscore.pointsKey)
    }
    
    private func getUrl() -> URL {
        let directory = FileManager().urls(for: .documentDirectory,
                                           in: .userDomainMask).first!
        return directory.appendingPathComponent(Highscore.directoryKey)
    }
}
