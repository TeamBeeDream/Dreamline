//
//  SkyNode.swift
//  AestheticTestA
//
//  Created by BeeDream on 4/21/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class SkyNode: SKNode {
    
    // MARK: Private Properties
    
    private var background: SKShapeNode!
    
    private var scrollShader: SKShader!
    private let speedUniformKey = "u_scroll_speed"
    private let scaleUniformKey = "u_scale_y"
    
    // MARK: Init
    
    static func make(frame: CGRect) -> SkyNode {
        let instance = SkyNode()
        instance.addSolidBackground(frame: frame)
        instance.addClouds(frame: frame)
        return instance
    }
    
    // MARK: Public Methods
    
    func setScrollSpeed(speed: Double) {
        self.scrollShader.uniformNamed(speedUniformKey)?.floatValue = Float(speed)
    }
    
    func setSkyColor(color: UIColor) {
        self.background.fillColor = color
    }
    
    // MARK: Private Properties
    
    private func addSolidBackground(frame: CGRect) {
        let background = SKShapeNode(rect: frame)
        background.lineWidth = 0.0
        background.fillColor = .black
        self.addChild(background)
        self.background = background
    }
    
    private func addClouds(frame: CGRect) {
        let shader = SKShader(fileNamed: "ScrollTexture.fsh")
        shader.addUniform(SKUniform(name: speedUniformKey, float: 0.0))
        shader.addUniform(SKUniform(name: scaleUniformKey, float: 1.0))
        let cloudTexture = SKTexture(imageNamed: "TiledSky1")
        self.scrollShader = shader
        
        let clouds = SKSpriteNode(texture: cloudTexture, size: frame.size)
        clouds.shader = shader
        clouds.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(clouds)
    }
}
