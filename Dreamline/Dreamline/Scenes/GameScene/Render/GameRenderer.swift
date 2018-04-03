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
    func roundOver() // @HACK
    func free()
}

// TODO: move to own file
class DebugRenderer: SKNode, GameRenderer {
    
    var cachedNodes = GenericNodeCache()
    var cachedFrame: CGRect
    
    // TEMP GRAPHICS
    var playerNode: SKNode
    var focusNode: FocusNode
    var playerPrevPos: Double
    var scoreText: SKLabelNode
    var thumbButtonLeft: SKSpriteNode
    var thumbButtonRight: SKSpriteNode
    let alphaLow: CGFloat = 0.2
    let alphaHigh: CGFloat = 0.5
    
    // @TODO: Change this to a static make() method.
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
        
        // Create Focus node
        let focus = FocusNode.make(level: 3, maxLevel: 3) // @HARDCODED
        self.focusNode = focus
        
        // Create score text
        self.scoreText = SKLabelNode()
        self.scoreText.position = CGPoint(x: frame.midX, y: frame.midY)
        self.scoreText.fontColor = .clear
        
        // Create thumb buttons
        let button = SKSpriteNode(imageNamed: "ThumbButton")
        button.size = CGSize(width: 60, height: 60)
        button.alpha = self.alphaLow
        
        self.thumbButtonLeft = button.copy() as! SKSpriteNode
        self.thumbButtonLeft.position = frame.point(x: -0.5, y: 0.6)
        self.thumbButtonRight = button.copy() as! SKSpriteNode
        self.thumbButtonRight.xScale = -1.0
        self.thumbButtonRight.position = frame.point(x: 0.5, y: 0.6)
        
        
        super.init() // Awkward how this has to happen in the middle
        
        // Add everything to the view
        self.addChild(self.playerNode)
        self.addChild(self.focusNode)
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
                
            case .entityAdd(let entity):
                self.cacheEntity(entity, layout: state.boardState.layout)
                
            case .entityDestroy(let entityId):
                self.deleteEntity(entityId)
                
            case .barrierPass(let entityId):
                self.fadeOutEntity(entityId)
                
            case .modifierGet(let entityId, _):
                self.fadeOutEntity(entityId)
                
            case .focusGain:
                self.focusNode.raiseLevel()
                
            case .focusLoss:
                self.focusNode.lowerLevel()
                
            default: break
            }
        }
        
        // Update all BarrierNodes
        for entity in state.boardState.entities {
            let position = self.cachedFrame.point(x: 0.0, y: entity.position).y
            self.cachedNodes.updateNodePosition(id: entity.id,
                                                position: position)
        }
        
        // Update temp player node
        let offset = state.positionState.offset * state.boardState.layout.laneOffset
        self.playerNode.position = self.cachedFrame.point(x: offset,
                                         y: state.boardState.layout.playerPosition)
        self.focusNode.updatePosition(xPos: self.playerNode.position.x)
        self.focusNode.position.y = self.playerNode.position.y - 20.0
        
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
    
    // @RENAME: All this method does is play the kill animation
    func killPlayer() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let fadeIn = SKAction.fadeIn(withDuration: 0)
        
        // @TEMP
        self.playerNode.run(SKAction.repeat(SKAction.sequence([fadeOut, fadeIn]), count: 4))
        
        /*
        self.playerNode.run(SKAction.group([
            SKAction.scale(to: 2.0, duration: 0.45),
            SKAction.fadeOut(withDuration: 0.45)]))
        */
    }
    
    func roundOver() {
        let titleLabel = SKLabelNode(text: "ROUND OVER")
        titleLabel.position = CGPoint(x: cachedFrame.midX, y: cachedFrame.midY)
        titleLabel.fontColor = .white
        titleLabel.alpha = 0
        titleLabel.fontSize = 40
        self.addChild(titleLabel)
        titleLabel.run(SKAction.fadeIn(withDuration: 0.1))
        // @NOTE: Having to remember to use cachedFrame is annoying
        
        self.scoreText.run(SKAction.fadeOut(withDuration: 0))
    }
    
    func free() {
        self.cachedNodes.free()
        
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    private func cacheEntity(_ entity: Entity, layout: BoardLayout) {
        switch (entity.data) {
        case .barrier(let barrier):
            let node = BarrierNode(layout: layout,
                                   width: Double(self.cachedFrame.width))
            node.drawOnce(barrier: barrier, status: entity.status)
            self.cachedNodes.addNode(node, entity: entity)
        case .empty:
            let node = EmptyNode()
            node.drawOnce(frameMinX: self.cachedFrame.minX,
                          frameMaxX: self.cachedFrame.maxX)
            self.cachedNodes.addNode(node, entity: entity)
        case .threshold:
            let node = ThresholdNode.make(frame: self.cachedFrame)
            self.cachedNodes.addNode(node, entity: entity)
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
            self.cachedNodes.addNode(node, entity: entity)
        }
    }
    
    private func deleteEntity(_ id: Int) {
        self.cachedNodes.deleteNode(id: id)
    }
    
    private func fadeOutEntity(_ id: Int) {
        self.cachedNodes.fadeOutNode(id: id)
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

