//
//  SelectRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/4/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import FirebaseAnalytics

class SelectRenderer: Observer {
    
    private var scene: SKScene!
    private var delegate: EventDelegate!
    
    private var container: SKNode!
    private var levelLabel: SKLabelNode!
    private var leftArrow: ButtonNode!
    private var rightArrow: ButtonNode!
    private var playButton: ButtonNode!
    
    private var level: Int = 1
    
    static func make(scene: SKScene, delegate: EventDelegate) -> SelectRenderer {
        let instance = SelectRenderer()
        instance.scene = scene
        instance.delegate = delegate
        instance.setup()
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .flowControlPhaseUpdate(let phase):
            self.handlePhase(phase: phase)
        default:
            break
        }
    }
    
    private func setup() {
        let layoutX = Layout.autoLayout(fullLength: self.scene.frame.width, segments: 2)
        let layoutY = Layout.autoLayout(fullLength: self.scene.frame.height, segments: 5)
        
        let label = SKLabelNode(text: "Round Select")
        label.fontColor = Colors.gray
        label.fontName = "Avenir-Light"
        label.fontSize = 30
        label.position = CGPoint(x: self.scene.frame.midX, y: layoutY.positions[3])
        
        let levelLabel = SKLabelNode(text: "\(self.level)")
        levelLabel.fontName = "Avenir-Light"
        levelLabel.fontColor = Colors.gray
        levelLabel.fontSize = 48
        levelLabel.verticalAlignmentMode = .center
        levelLabel.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        self.levelLabel = levelLabel
        
        let arrowTexture = Resources.shared.getTexture(.arrowButton)
        let arrowSize = CGSize(width: layoutX.sublength * 0.25, height: layoutX.sublength * 0.25)
        
        self.leftArrow = self.makeButton(texture: arrowTexture, size: arrowSize, xScale: +1)
        self.leftArrow.action = { self.changeLevel(increment: -1) }
        self.leftArrow.position = CGPoint(x: layoutX.positions[0], y: self.scene.frame.midY)
        
        self.rightArrow = self.makeButton(texture: arrowTexture, size: arrowSize, xScale: -1)
        self.rightArrow.action = { self.changeLevel(increment: +1) }
        self.rightArrow.position = CGPoint(x: layoutX.positions[1], y: self.scene.frame.midY)
        
        let playButton = ButtonNode(texture: Resources.shared.getTexture(.playButton))
        playButton.position = CGPoint(x: self.scene.frame.midX, y: layoutY.positions[1])
        playButton.isUserInteractionEnabled = true
        playButton.action = {
            self.delegate.addEvent(.chunkLevelUpdate(level: self.level))
            self.delegate.addEvent(.flowControlPhaseUpdate(phase: .begin))
            Analytics.logEvent("v1_0_round_select",
                               parameters: ["level": self.level as NSObject])
        }
        self.playButton = playButton
        
        self.container = SKNode()
        self.container.zPosition = 100 // @HARDCODED
        self.container.alpha = 0.0
        self.container.addChild(self.levelLabel)
        self.container.addChild(self.leftArrow)
        self.container.addChild(self.rightArrow)
        self.container.addChild(label)
        self.container.addChild(self.playButton)
        self.scene.addChild(self.container)
    }
    
    private func makeButton(texture: SKTexture, size: CGSize, xScale: Int) -> ButtonNode {
        let button = ButtonNode(texture: texture, size: size)
        button.color = Colors.gray
        button.colorBlendFactor = 0.8
        button.xScale = CGFloat(xScale)
        button.zPosition = 200 // @HARDCODED
        button.isUserInteractionEnabled = true
        return button
    }
    
    private func handlePhase(phase: FlowControlPhase) {
        switch phase {
        case .select:
            self.container.run(Actions.fadeIn(duration: 0.2))
        case .begin:
            self.container.run(Actions.fadeOut(duration: 0.2))
        default:
            break
        }
    }
    
    private func changeLevel(increment: Int) {
        self.level = clamp(level + increment, min: 1, max: 9)
        self.levelLabel.text = "\(self.level)"
    }
}
