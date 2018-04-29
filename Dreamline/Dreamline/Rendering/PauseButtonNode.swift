//
//  PauseButton.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class PauseButtonNode: ButtonNode {
    static func make(size: CGSize) -> PauseButtonNode {
        let instance = PauseButtonNode(color: .orange, size: size)
        instance.zPosition = 50 // @HARDCODED
        instance.isUserInteractionEnabled = true
        return instance
    }
}
