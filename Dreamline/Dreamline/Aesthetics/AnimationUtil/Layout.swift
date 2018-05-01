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
    
    static func autoLayout(fullLength: CGFloat, segments: Int) -> (sublength: CGFloat, positions: [CGFloat]) {
        let sublength = fullLength / CGFloat(segments)
        var positions = [CGFloat]()
        for i in 0...segments {
            let pos = (sublength / 2) + (CGFloat(i) * sublength)
            positions.append(pos)
        }
        return (sublength: sublength, positions: positions)
    }
}
