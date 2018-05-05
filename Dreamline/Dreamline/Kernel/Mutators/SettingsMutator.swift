//
//  SettingsMutator.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class SettingsMutator: Mutator {
    func mutateState(state: inout KernelState, event: KernelEvent) {
        switch event {
        case .settingsMuteUpdate(let mute):
            state.settings.audioMuted = mute
        default:
            break
        }
    }
}
