//
//  SkyNode.swift
//  Dreamline
//
//  Created by BeeDream on 4/4/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

enum SkyColor {
    case blue
    case green
    
    // @TODO: Expand color selection
    //case pink
    //case orange
}

extension SkyColor {
    func uiColor() -> UIColor {
        switch self {
        case .blue:
            return UIColor(red: 196.0/255.0, green: 229.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        case .green:
            return .green
        }
    }
}

// @NOTE: Should this be an SKNode, or just own one?
class SkyNode: SKNode {
    
    // MARK: Private Properties
    
    private var skyColor: SkyColor!
    private var bgNode: SKShapeNode!
    private var cloudsNode: SKSpriteNode!
    
    // MARK: Init
    
    static func make(rect: CGRect) -> SkyNode {
        let skyColor = SkyColor.blue    // @HARDCODED: Blue by default
        
        let bgNode = SKShapeNode(rect: rect)
        bgNode.lineWidth = 0
        bgNode.fillColor = skyColor.uiColor()
        
        let shader = SKShader(fileNamed: "ScrollShader.fsh")
        let texture = SKTexture(imageNamed: "TiledSky1")
        
        let cloudsNode = SKSpriteNode(texture: texture, size: rect.size)
        cloudsNode.shader = shader
        cloudsNode.position = CGPoint(x: rect.midX, y: rect.midY)
        
        let instance = SkyNode()
        instance.skyColor = skyColor
        instance.bgNode = bgNode
        instance.addChild(bgNode)
        instance.cloudsNode = cloudsNode
        instance.addChild(cloudsNode)
        return instance
    }
    
    // MARK: Public Methods

    func changeSkyColor(_ color: SkyColor) {
        self.skyColor = color
        self.bgNode.fillColor = color.uiColor()
    }
}

