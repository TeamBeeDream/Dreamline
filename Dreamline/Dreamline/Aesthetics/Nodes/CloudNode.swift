//
//  CloudNode.swift
//  Dreamline
//
//  Created by BeeDream on 5/2/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class CloudNode: SKNode {
    
    private var sprite: SKSpriteNode!
    private var scrollShader: SKShader!
    
    private let speedXUniformKey = "u_scroll_speed_x"
    private let speedYUniformKey = "u_scroll_speed_y"
    private let colorUniformKey = "u_tint_color"
    
    static func make(width: CGFloat) -> CloudNode {
        let instance = CloudNode()
        instance.addClouds(width: width)
        return instance
    }
    
    // MARK: Public Methods
    
    func setScrollSpeed(x: Double, y: Double) {
        self.scrollShader.uniformNamed(speedXUniformKey)?.floatValue = Float(x)
        self.scrollShader.uniformNamed(speedYUniformKey)?.floatValue = Float(y)
    }
    
    func setTint(r: Double, g: Double, b: Double, a: Double) {
        let color = vector4(Float(r), Float(g), Float(b), Float(a))
        self.scrollShader.uniformNamed(colorUniformKey)?.vectorFloat4Value = color
    }
    
    // MARK: Private Properties
    
    private func addClouds(width: CGFloat) {
        let shader = SKShader(fileNamed: "CloudScroll.fsh")
        shader.addUniform(SKUniform(name: speedXUniformKey, float: 0.0))
        shader.addUniform(SKUniform(name: speedYUniformKey, float: 0.0))
        shader.addUniform(SKUniform(name: colorUniformKey, vectorFloat4: vector4(1.0, 1.0, 1.0, 1.0)))
        self.scrollShader = shader
        
        let cloudTexture = Resources.shared.getTexture(.tiledCloud1)
        let clouds = SKSpriteNode(texture: cloudTexture, size: CGSize(width: width, height: width))
        clouds.shader = shader
        clouds.position = CGPoint(x: width / 2.0, y: width / 2.0)
        self.addChild(clouds)
    }
}
