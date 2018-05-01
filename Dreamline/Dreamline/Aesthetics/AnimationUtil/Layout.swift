//
//  Layout.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class Layout {
    static func safeRect(rect: CGRect, margin: CGFloat) -> CGRect {
        let marginInPixels = rect.width * margin
        return rect.insetBy(dx: marginInPixels, dy: marginInPixels)
    }
}
