//
//  SkyRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class SkyRenderer: Observer {
    
    private var scene: SKScene!
    private var matteNode: SKNode!
    
    static func make(scene: SKScene) -> SkyRenderer {
        let instance = SkyRenderer()
        instance.scene = scene
        instance.addSky(rect: scene.frame)
        instance.addMatte(rect: scene.frame)
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .flowControlPhaseUpdate(let phase):
            self.handlePhaseUpdate(phase)
        default: break
        }
    }
    
    private func addSky(rect: CGRect) {
        let bg = SKSpriteNode(color: Colors.sky, size: self.scene.frame.size)
        bg.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        self.scene.addChild(bg)
        let clouds = ScrollingCloudClusterNode.make(count: 4, bounds: self.scene.frame, vertical: true)
        self.scene.addChild(clouds)
    }
    
    private func addMatte(rect: CGRect) {
        
        let scale = 4.0
        let proportion = Double(rect.height / rect.width)
        
        let color = UIColor(red: 43.0/255.0, green: 37.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        let texture = Resources.shared.getTexture(.tiledCloudBG)
        let shader = SKShader(fileNamed: "TiledTexture.fsh")
        shader.addUniform(SKUniform(name: "u_scale_x", float: Float(scale)))
        shader.addUniform(SKUniform(name: "u_scale_y", float: Float(scale * proportion)))
        shader.addUniform(SKUniform(name: "u_alpha", float: 0.1))
        shader.addUniform(SKUniform(name: "u_scroll_speed_x", float: 0.1))
        shader.addUniform(SKUniform(name: "u_scroll_speed_y", float: 0.05))
        
        let texturedMatte = SKSpriteNode(texture: texture, size: rect.size)
        texturedMatte.zPosition = 0
        texturedMatte.shader = shader
        
        let coloredMatte = SKSpriteNode(color: color, size: rect.size)
        texturedMatte.zPosition = 1
        
        let matte = SKNode()
        matte.addChild(coloredMatte)
        matte.addChild(texturedMatte)
        matte.position = CGPoint(x: rect.midX, y: rect.midY)
        matte.zPosition = 4
        matte.alpha = 0.0
        self.scene.addChild(matte)
        self.matteNode = matte
    }
    
    private func handlePhaseUpdate(_ phase: FlowControlPhase) {
        switch phase {
        case .select: fallthrough
        case .begin:
            self.run(self.matteNode, action: Actions.fadeOut(duration: 0.2))
        case .results:
            self.run(self.matteNode, action: Actions.fadeIn(duration: 0.5))
        default:
            break
        }
    }
    
    private func run(_ node: SKNode, action: SKAction) {
        node.removeAllActions()
        node.run(action)
    }
}
