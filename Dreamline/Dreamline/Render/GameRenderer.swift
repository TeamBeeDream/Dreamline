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
    func render(state: ModelState, config: GameConfig, events: [Event])
}

// @HACK: i'm using this as a placeholder so i don't have to
// make an init() func for GameController, which is silly (and will be fixed)
class DummyRenderer: GameRenderer {
    func render(state: ModelState, config: GameConfig, events: [Event]) {
        // do nothing
    }
}

// TODO: move to own file
class DebugRenderer: SKNode, GameRenderer {
    // @NOTE: I think Xcode has smoothing on all
    // of its UI, or everything has artificially
    // smooth animation so it feels soft.
    
    var playerNode: SKNode
    var barrierCache: [Int: BarrierNode]
    var cachedFrame: CGRect
    
    // @CLEANUP: this is ugly
    init(frame: CGRect) {
        self.cachedFrame = frame
        self.barrierCache = [Int: BarrierNode]()
        let radius = CGFloat(0.2) * (320.0) / 4.0 // @HARDCODED
        let playerGraphic = SKShapeNode(circleOfRadius: radius)
        playerGraphic.lineWidth = 0
        playerGraphic.fillColor = SKColor.red
        self.playerNode = playerGraphic
        super.init() // this is super awkward
        self.awake()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func awake() {
        self.playerNode.position = self.point(x: -9999.9, y: -9999.9) // haha
        addChild(self.playerNode)
    }
    
    func render(state: ModelState, config: GameConfig, events: [Event]) {
        // @TODO: could probably break these out to different methods
        // ex: handleEvents, updateEntities, updatePlayer, etc.
        
        // 1. loop through event queue
        for event in events {
            switch (event) {
            case .barrierAdded(let barrier):
                self.cacheBarrier(barrier, layout: state.boardLayout)
            case .barrierDestroyed(let barrierId):
                self.deleteBarrier(barrierId)
            case .barrierPass(let id):
                self.passBarrier(id)
            case .barrierHit(let id):
                self.hitBarrier(id)
            default: break
            }
        }
        
        // 2. update all barriers
        for barrierData in state.boardState.barriers {
            let barrierNode = self.barrierCache[barrierData.id]!
            barrierNode.position.y = point(x: 0.0, y: barrierData.position).y
        }
        
        // 3. update player
        let position = state.positioner.getPosition(state: state.positionerState, config: config)
        let offset = position.offset * state.boardLayout.laneOffset
        self.playerNode.position = point(x: offset, y: state.boardLayout.playerPosition)
    }
    
    private func cacheBarrier(_ barrier: Barrier, layout: BoardLayout) {
        let node = BarrierNode(layout: layout, width: Double(self.cachedFrame.width))
        node.drawOnce(barrier: barrier)
        addChild(node)
        self.barrierCache[barrier.id] = node
    }
    
    private func deleteBarrier(_ id: Int) {
        let node = self.barrierCache[id]!
        node.removeFromParent()
        self.barrierCache[id] = nil
    }
    
    private func passBarrier(_ barrierId: Int) {
        let node = self.barrierCache[barrierId]!
        node.run(SKAction.sequence([
            SKAction.run { node.makeColor(.white) },
            SKAction.wait(forDuration: 0.05),
            SKAction.run { node.makeColor(.green) },
            SKAction.fadeAlpha(to: 0.0, duration: 0.3)]))
    }
    
    private func hitBarrier(_ barrierId: Int) {
        let node = self.barrierCache[barrierId]!
        node.run(SKAction.sequence([
            SKAction.run { node.makeColor(.white) },
            SKAction.wait(forDuration: 0.05),
            SKAction.run { node.makeColor(.red) },
            SKAction.fadeAlpha(to: 0.0, duration: 0.5)]))
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

