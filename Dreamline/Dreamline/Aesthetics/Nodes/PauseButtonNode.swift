//
//  PauseButton.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class PauseButtonNode: ButtonNode {
    static func make(size: CGFloat) -> PauseButtonNode {
        let texture = Resources.shared.getTexture(.pauseButton)
        let instance = PauseButtonNode(texture: texture, size: CGSize(width: size, height: size))
        instance.zPosition = 35 // @HARDCODED
        instance.isUserInteractionEnabled = true
        return instance
    }
}
