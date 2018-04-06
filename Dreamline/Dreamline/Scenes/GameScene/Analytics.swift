//
//  Analytics.swift
//  Dreamline
//
//  Created by BeeDream on 4/6/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

// @TODO: Move this file somewhere better

import Foundation
import Firebase

// @RENAME
protocol AnalyticsListener {
    func processEvents(_ events: [Event], config: GameConfig)
}

class DefaultAnalyticsListener: AnalyticsListener {
    
    // MARK: Private Properties
    
    private var barriersTotal: Int = 0
    private var barriersPassed: Int = 0
    
    // MARK: Init
    
    static func make() -> DefaultAnalyticsListener {
        let instance = DefaultAnalyticsListener()
        return instance
    }
    
    // MARK: AnalyticsListener Methods
    
    func processEvents(_ events: [Event], config: GameConfig) {
        for event in events {
            switch event {
                
            case .barrierHit:
                self.barriersTotal += 1
                
            case .barrierPass:
                self.barriersTotal += 1
                self.barriersPassed += 1
                
            case .thresholdCross(let type):
                if type == .speedUp { self.logAndReset(config: config, complete: true) }
                
            case .focusGone: // @HACK
                self.logAndReset(config: config, complete: false)
                
            default:
                break
                
            }
            
        }
    }
    
    // MARK: Private Methods
    
    private func logAndReset(config: GameConfig, complete: Bool) {
        // Log the stats collected up until this point and reset private properties
        
        let difficulty = config.boardScrollSpeed.rawValue
        let total = self.barriersTotal
        let percentage = Double(self.barriersPassed) / Double(self.barriersTotal)
        
        Analytics.logEvent("beta__0_2__section_complete",
                           parameters: ["difficulty": difficulty as NSObject,
                                        "total": total as NSObject,
                                        "percentage": percentage as NSObject,
                                        "complete": complete as NSObject])
        
        // Reset
        self.barriersPassed = 0
        self.barriersTotal = 0
    }
}
