//
//  GameRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 3/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

protocol GameRenderer {
    func render(state: ModelState, score: Score, config: GameConfig, events: [Event])
    func killPlayer() // @HACK
    func free()
}

// TODO: move to own file
class DebugRenderer: SKNode, GameRenderer {
    
    var cachedNodes = GenericNodeCache()
    var cachedFrame: CGRect
    
    // TEMP GRAPHICS
    var playerNode: SKNode
    var playerPrevPos: Double
    var scoreText: SKLabelNode
    var thumbButtonLeft: SKSpriteNode
    var thumbButtonRight: SKSpriteNode
    let alphaLow: CGFloat = 0.2
    let alphaHigh: CGFloat = 0.5
    
    init(frame: CGRect) {
        
        // @NOTE: This is awkward
        //        We need to store the frame in order
        //        for to know how big to draw things
        //        I think this might be alleviated by changing
        //        this from an SKNode to an SKView
        self.cachedFrame = frame
        
        // Create player node
        let player = SKSpriteNode(imageNamed: "Player")
        player.size = CGSize(width: 20, height: 20) // @HARDCODED
        self.playerNode = player
        self.playerPrevPos = 0.0
        
        // Create score text
        self.scoreText = SKLabelNode()
        self.scoreText.position = CGPoint(x: frame.midX, y: frame.maxX - 50.0)
        self.scoreText.color = SKColor.white
        
        // Create thumb buttons
        let button = SKSpriteNode(imageNamed: "ThumbButton")
        button.size = CGSize(width: 60, height: 60)
        button.alpha = self.alphaLow
        
        self.thumbButtonLeft = button.copy() as! SKSpriteNode
        self.thumbButtonLeft.position = frame.point(x: -0.5, y: 0.8)
        self.thumbButtonRight = button.copy() as! SKSpriteNode
        self.thumbButtonRight.xScale = -1.0
        self.thumbButtonRight.position = frame.point(x: 0.5, y: 0.8)
        
        
        super.init() // Awkward how this has to happen in the middle
        
        // Add everything to the view
        self.addChild(self.playerNode)
        self.addChild(self.cachedNodes)
        self.addChild(self.scoreText)
        self.addChild(self.thumbButtonLeft)
        self.addChild(self.thumbButtonRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(state: ModelState,
                score: Score,
                config: GameConfig,
                events: [Event]) {
        
        // @TODO: Could probably break these out to different methods
        // E.x.: handleEvents, updateEntities, updatePlayer, etc.
        
        // Loop through event queue
        for event in events {
            switch (event) {
                
            case .triggerAdded(let trigger):
                self.cacheTrigger(trigger, layout: state.boardState.layout)
            case .triggerDestroyed(let triggerId):
                self.deleteTrigger(triggerId)
            case .barrierPass(let triggerId):
                self.fadeOutTrigger(triggerId)
            case .modifierGet(let triggerId, _):
                self.fadeOutTrigger(triggerId)
            default: break
            }
        }
        
        // Update all BarrierNodes
        for trigger in state.boardState.triggers {
            let position = self.cachedFrame.point(x: 0.0, y: trigger.position).y
            self.cachedNodes.updateNodePosition(triggerId: trigger.id,
                                                position: position)
        }
        
        // Update temp player node
        let offset = state.positionState.offset * state.boardState.layout.laneOffset
        self.playerNode.position = self.cachedFrame.point(x: offset,
                                         y: state.boardState.layout.playerPosition)
        
        let diff = state.positionState.offset - self.playerPrevPos
        self.playerNode.zRotation = CGFloat(diff * -3.0) // @HARDCODED
        self.playerPrevPos = state.positionState.offset
        
        // Update Score Text
        self.scoreText.text = String(score.points)
        
        // Update thumb buttons
        let target = state.positionState.target
        if target > 0.0 {
            // Right
            self.thumbButtonLeft.alpha = self.alphaLow
            self.thumbButtonRight.alpha = self.alphaHigh
        } else if target < 0.0 {
            // Left
            self.thumbButtonLeft.alpha = self.alphaHigh
            self.thumbButtonRight.alpha = self.alphaLow
        } else {
            // Center
            self.thumbButtonLeft.alpha = self.alphaLow
            self.thumbButtonRight.alpha = self.alphaLow
        }
    }
    
    func killPlayer() {
        self.playerNode.run(SKAction.group([
            SKAction.scale(to: 2.0, duration: 0.45),
            SKAction.fadeOut(withDuration: 0.45)]))
    }
    
    func free() {
        self.cachedNodes.free()
        
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    private func cacheTrigger(_ trigger: Trigger, layout: BoardLayout) {
        switch (trigger.type) {
        case .barrier(let barrier):
            let node = BarrierNode(layout: layout,
                                   width: Double(self.cachedFrame.width))
            node.drawOnce(barrier: barrier, status: trigger.status)
            self.cachedNodes.addNode(node, data: trigger)
        case .empty:
            let node = EmptyNode()
            node.drawOnce(frameMinX: self.cachedFrame.minX,
                          frameMaxX: self.cachedFrame.maxX)
            self.cachedNodes.addNode(node, data: trigger)
        case .modifier(let modifierRow):
            
            // @NOTE: This is a little awkward
            //        When passing down information dependent on the frame
            //        the delivery becomes clumsy
            var positions = [CGPoint]()
            positions.append(self.cachedFrame.point(x: -layout.laneOffset, y: 0.0))
            positions.append(self.cachedFrame.point(x: 0.0, y: 0.0))
            positions.append(self.cachedFrame.point(x: layout.laneOffset, y: 0.0))
            
            let node = ModifierNode()
            node.drawOnce(row: modifierRow, positions: positions)
            self.cachedNodes.addNode(node, data: trigger)
        }
    }
    
    private func deleteTrigger(_ id: Int) {
        self.cachedNodes.deleteNode(triggerId: id)
    }
    
    private func fadeOutTrigger(_ id: Int) {
        self.cachedNodes.fadeOutNode(triggerId: id)
    }
}

// @CLEANUP: Move to Math(?)
extension CGRect {
    func point(x: Double, y: Double) -> CGPoint {
        return point(x: CGFloat(x), y: CGFloat(y))
    }
    
    func point(x: CGFloat, y: CGFloat) -> CGPoint {
        let convertedX = self.midX + (x * self.width / 2.0)
        let convertedY = self.midY - (y * self.height / 2.0)
        return CGPoint(x: convertedX, y: convertedY)
    }
}

