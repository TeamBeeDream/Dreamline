//
//  FirebaseObserver.swift
//  Dreamline
//
//  Created by BeeDream on 5/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class FirebaseObserver: Observer {
    
    func observe(event: KernelEvent) {
        switch event {
        case .roundOver(let didWin, let level, let score):
            if !didWin {
                Analytics.logEvent("v1_0_round_over",
                                   parameters: ["level": level,
                                                "score": score])
            }
        default:
            break
        }
    }
}
