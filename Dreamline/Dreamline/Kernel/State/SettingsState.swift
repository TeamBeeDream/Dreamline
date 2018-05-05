//
//  SettingsState.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

struct SettingsState {
    var audioMuted: Bool
}

extension SettingsState {
    static func new() -> SettingsState {
        return SettingsState(audioMuted: false)
    }
}
