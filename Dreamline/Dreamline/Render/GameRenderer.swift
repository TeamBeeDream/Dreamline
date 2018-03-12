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
    func free()
}

// TODO: move to own file
class DebugRenderer: SKNode, GameRenderer {
    
    var playerNode: SKNode
    var cachedNodes = GenericNodeCache()
    var cachedFrame: CGRect // @FIXME
    
    var scoreText: SKLabelNode
    
    // @CLEANUP: this is ugly
    init(frame: CGRect) {
        self.cachedFrame = frame
        let radius = CGFloat(0.2) * (320.0) / 4.0 // @HARDCODED
        let playerGraphic = SKShapeNode(circleOfRadius: radius)
        playerGraphic.lineWidth = 0
        playerGraphic.fillColor = SKColor.red
        self.playerNode = playerGraphic
        
        self.scoreText = SKLabelNode()
        self.scoreText.position = CGPoint(x: frame.midX, y: frame.maxX - 50.0)
        self.scoreText.color = SKColor.white
        
        super.init() // this is super awkward
        
        self.awake()
        self.addChild(self.cachedNodes)
        self.addChild(self.scoreText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func awake() {
        self.playerNode.position = self.point(x: -9999.9, y: -9999.9) // haha, gross
        addChild(self.playerNode)
    }
    
    func render(state: ModelState, score: Score, config: GameConfig, events: [Event]) {
        // @TODO: could probably break these out to different methods
        // ex: handleEvents, updateEntities, updatePlayer, etc.
        
        // 1. loop through event queue
        for event in events {
            switch (event) {
            case .triggerAdded(let trigger):
                self.cacheTrigger(trigger, layout: state.boardLayout)
            case .triggerDestroyed(let triggerId):
                self.deleteTrigger(triggerId)
            default: break
            }
        }
        
        // 2. update all barriers
        for trigger in state.boardState.triggers {
            let position = point(x: 0.0, y: trigger.position).y
            self.cachedNodes.updateNodePosition(triggerId: trigger.id, position: position)
        }
        
        // 3. update player
        let position = state.positioner.getPosition(state: state.positionerState, config: config)
        let offset = position.offset * state.boardLayout.laneOffset
        self.playerNode.position = point(x: offset, y: state.boardLayout.playerPosition)
        
        // 4. update score
        self.scoreText.text = String(score.points)
    }
    
    func free() {
        self.cachedNodes.free()
        
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    private func cacheTrigger(_ trigger: Trigger, layout: BoardLayout) {
        switch (trigger.type) {
        case .barrier(let barrier):
            let node = BarrierNode(layout: layout, width: Double(self.cachedFrame.width))
            node.drawOnce(barrier: barrier, status: trigger.status)
            self.cachedNodes.addNode(node, data: trigger)
        case .empty:
            let node = EmptyNode(frameMinX: Double(cachedFrame.minX),
                                 frameMaxX: Double(cachedFrame.maxX))
            node.drawOnce()
            self.cachedNodes.addNode(node, data: trigger)
        case .modifier(let modifierRow):
            let node = ModifierNode()
            var positions = [CGPoint]() // i don't like this
            positions.append(point(x: -layout.laneOffset, y: 0.0))
            positions.append(point(x: 0.0, y: 0.0))
            positions.append(point(x: layout.laneOffset, y: 0.0))
            node.drawOnce(row: modifierRow, positions: positions)
            self.cachedNodes.addNode(node, data: trigger)
        }
    }
    
    private func deleteTrigger(_ id: Int) {
        self.cachedNodes.deleteNode(triggerId: id)
    }
    
    // @CLEANUP: this method should probably be static somewhere
    private func point(x: Double, y: Double) -> CGPoint {
        return point(x: CGFloat(x), y: CGFloat(y))
    }
    
    private func point(x: CGFloat, y: CGFloat) -> CGPoint {
        let convertedX = self.cachedFrame.midX + (x * self.cachedFrame.width / 2.0)
        let convertedY = self.cachedFrame.midY - (y * self.cachedFrame.height / 2.0)
        return CGPoint(x: convertedX, y: convertedY)
    }
}

