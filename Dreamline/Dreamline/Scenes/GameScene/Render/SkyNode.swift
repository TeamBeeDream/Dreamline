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
    case pink
    case yellow
}

extension SkyColor {
    func uiColor() -> UIColor {
        switch self {
        case .blue:
            return UIColor(red: 118.0/255.0, green: 211.0/255.0, blue: 222.0/255.0, alpha: 1.0)
        case .green:
            return UIColor(red: 196.0/255.0, green: 229.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        case .pink:
            return UIColor(red: 252.0/255.0, green: 183.0/255.0, blue: 167.0/255.0, alpha: 1.0)
        case .yellow:
            return UIColor(red: 248.0/255.0, green: 221.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }
    }
    
    static func random() -> SkyColor {
        let colors: [SkyColor] = [.blue, .green, .pink, .yellow] // @ROBUSTNESS
        let random = RealRandom() // @HARDCODED
        let randomIndex = random.nextInt(min: 0, max: colors.count - 1)
        return colors[randomIndex]
    }
}

// @NOTE: Should this be an SKNode, or just own one?
// @NOTE: This class should exclusively manage how the
// sky is drawn, and a controller should sit above this
// Then you would get things like the ability to smoothly
// blend between colors without making this class enourmous
class SkyNode: SKNode {
    
    // MARK: Private Properties
    
    // @NOTE: It probably doesn't make much sense to limit
    // the number of sky colors, it's convenient, but
    // should probably just take in a UIColor
    private var skyColor: SkyColor!
    private var scrollSpeed: Float!
    
    // MARK: Private Nodes
    
    private var bgNode: SKShapeNode!
    private var cloudsNode: SKSpriteNode!
    private var scrollShader: SKShader!
    
    // MARK: Init
    
    static func make(rect: CGRect, skyColor: SkyColor, scrollSpeed: Float) -> SkyNode {
        // Flat background sky color
        let bgNode = SKShapeNode(rect: rect)
        bgNode.lineWidth = 0
        bgNode.fillColor = skyColor.uiColor()
        
        // Scrolling shader
        let shader = SKShader(fileNamed: "ScrollShader.fsh")
        shader.addUniform(SKUniform(name: "u_scroll_speed", float: scrollSpeed))
        
        // Cloud texture
        let texture = SKTexture(imageNamed: "TiledSky1")
        
        // Cloud node
        let cloudsNode = SKSpriteNode(texture: texture, size: rect.size)
        cloudsNode.shader = shader
        cloudsNode.position = CGPoint(x: rect.midX, y: rect.midY)
        
        // Final composited node
        let instance = SkyNode()
        instance.skyColor = skyColor
        instance.bgNode = bgNode
        instance.cloudsNode = cloudsNode
        instance.scrollShader = shader
        
        // @NOTE: Would be interesting if this class didn't
        // add subnodes to itself, instead it was passed
        // a container to use
        instance.addChild(bgNode)
        instance.addChild(cloudsNode)
        return instance
    }
    
    // MARK: Public Methods

    func changeSkyColor(_ color: SkyColor) {
        self.skyColor = color
        self.bgNode.fillColor = color.uiColor()
    }
    
    func changeScrollSpeed(_ speed: Float) {
        self.scrollShader.uniformNamed("u_scroll_speed")?.floatValue = speed
    }
}

