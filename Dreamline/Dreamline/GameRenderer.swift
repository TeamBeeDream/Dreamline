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

// TODO: move to own file
class DebugRenderer: SKNode, GameRenderer {
    // @NOTE: I think Xcode has smoothing on all
    // of its UI, or everything has artificially
    // smooth animation so it feels soft.
    
    var playerNode: SKNode
    var barrierCache: [Int: BarrierNode]
    var cachedFrame: CGRect
    
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
        //print("rendering")
        
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
        
        // update player
        let position = state.positioner.getPosition(state: state.positionerState, config: config)
        let offset = position.offset * state.boardLayout.laneOffset
        self.playerNode.position = point(x: offset, y: state.boardLayout.playerPosition)
        //self.playerNode.fillColor = position.withinTolerance ? SKColor.green : SKColor.white
    }
//}
//extension DebugRender {
    private func cacheBarrier(_ barrier: Barrier, layout: BoardLayout) {
        let node = BarrierNode(layout: layout, width: Double(self.cachedFrame.width))
        node.drawOnce(barrier: barrier)
        addChild(node)
        self.barrierCache[barrier.id] = node
    }
    
    private func deleteBarrier(_ id: Int) {
        let node = self.barrierCache[id]!
        node.removeFromParent()
        //node = nil
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
    
    // this is weird
    func drawLayoutLines(layout: BoardLayout) {
        // spawn line
        addChild(createLine(
            from: point(x: -1.0, y: layout.spawnPosition),
            to: point(x: 1.0, y: layout.spawnPosition),
            color: SKColor.gray,
            width: 1.0))
        
        // destroy line
        addChild(createLine(
            from: point(x: -1.0, y: layout.destroyPosition),
            to: point(x: 1.0, y: layout.destroyPosition),
            color: SKColor.gray,
            width: 1.0))
        
        // player line
        addChild(createLine(
            from: point(x: -1.0, y: layout.playerPosition),
            to: point(x: 1.0, y: layout.playerPosition),
            color: SKColor.gray,
            width: 1.0))
        
        // lane lines
        addChild(createLine(
            from: point(x: -layout.laneOffset, y: layout.playerPosition),
            to: point(x: -layout.laneOffset, y: -1.0),
            color: SKColor.gray,
            width: 1.0))
        addChild(createLine(
            from: point(x: 0.0, y: layout.playerPosition),
            to: point(x: 0.0, y: -1.0),
            color: SKColor.gray,
            width: 1.0))
        addChild(createLine(
            from: point(x: layout.laneOffset, y: layout.playerPosition),
            to: point(x: layout.laneOffset, y: -1.0),
            color: SKColor.gray,
            width: 1.0))
    }
    
    private func point(x: Double, y: Double) -> CGPoint {
        return point(x: CGFloat(x), y: CGFloat(y))
    }
    
    private func point(x: CGFloat, y: CGFloat) -> CGPoint {
        let convertedX = self.cachedFrame.midX + (x * self.cachedFrame.width / 2.0)
        let convertedY = self.cachedFrame.midY - (y * self.cachedFrame.height / 2.0)
        return CGPoint(x: convertedX, y: convertedY)
    }
    
    private func createLine(from: CGPoint,
                            to: CGPoint,
                            color: SKColor,
                            width: CGFloat = 2.0) -> SKShapeNode {
        let node = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        node.path = path.cgPath
        node.strokeColor = color
        node.lineWidth = width
        return node
    }
}

class BarrierNode: SKNode {
    
    let layout: BoardLayout
    var boardWidth: Double
    var graphic: SKNode?
    var bits: [SKShapeNode]
    
    init(layout: BoardLayout, width: Double) {
        self.layout = layout
        self.boardWidth = width
        self.bits = [SKShapeNode]()
        super.init()
    }
    
    // @NOTE: I don't like this
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // @TODO: move to separate class (in graphics folder)
    // @RENAME
    func drawOnce(barrier: Barrier) {
        // @CLEANUP, this code is hard to understand
        let occupied = 1.0 - self.layout.laneOffset * 2
        let margin = (self.boardWidth * occupied) / 2.0
        let width = self.boardWidth - (margin * 2.0)
        let gateWidth = Double(width / 4.0)
        let gateHeight = 20.0 // @HARDCODED
        let wallY: Double = 0
        
        let barrierGraphic = SKNode()
        let wallColor = self.wallColor(barrier.status)
        let gateColor = self.gateColor(barrier.status)
        
        let data = self.barrierDataToBoolArray(data: barrier.pattern.data)
        for i in 1...4 {
            let prev = data[i-1]
            let curr = data[i]
            
            let prevX: Double = Double(i-1) * gateWidth + Double(margin)
            let currX: Double = Double(i) * gateWidth + Double(margin)
            let midX: Double = (prevX + currX) / 2.0
            let gateUpY: Double = -gateHeight / 2.0
            let gateDownY: Double = gateHeight / 2.0
            
            if prev != curr {
                let gate = self.createLine(from: CGPoint(x: midX, y: gateUpY),
                                           to: CGPoint(x: midX, y: gateDownY),
                                           color: gateColor)
                barrierGraphic.addChild(gate)
                self.bits.append(gate)
            }
            if !prev {
                let wall = self.createLine(from: CGPoint(x: prevX, y: wallY),
                                           to: CGPoint(x: midX, y: wallY),
                                           color: wallColor)
                barrierGraphic.addChild(wall)
                self.bits.append(wall)
            }
            if !curr {
                let wall = self.createLine(from: CGPoint(x: midX, y: wallY),
                                           to: CGPoint(x: currX, y: wallY),
                                           color: wallColor)
                barrierGraphic.addChild(wall)
                self.bits.append(wall)
            }
        }
        
        //return barrierGraphic
        self.graphic = barrierGraphic
        addChild(self.graphic!)
    }
    
    func makeColor(_ color: SKColor) {
        // gross
        var updatedBits = [SKShapeNode]()
        
        for node in self.bits {
            node.removeFromParent()
            let updatedNode = node.copy() as! SKShapeNode
            updatedNode.strokeColor = color
            updatedBits.append(updatedNode)
            addChild(updatedNode)
        }
        
        self.bits = updatedBits
    }
    
    
    // @TODO: would be interesting to put this in a generic 'actions' class
    private func getFadeAction() -> SKAction {
        return SKAction.fadeAlpha(to: 0.0, duration: 0.3)
    }
    
    private func getBadAnimation() -> SKAction {
        return SKAction.fadeAlpha(to: 0.0, duration: 0.4)
    }
    
    private func wallColor(_ status: BarrierStatus) -> SKColor {
        switch (status) {
        case .idle:
            return SKColor.magenta
        case .pass:
            return SKColor.green
        case .hit:
            return SKColor.red
        }
    }
    
    private func gateColor(_ status: BarrierStatus) -> SKColor {
        switch (status) {
        case .idle:
            return SKColor.cyan
        case .pass:
            return SKColor.green
        case .hit:
            return SKColor.red
        }
    }
    
    private func barrierDataToBoolArray(data: [Gate]) -> [Bool] {
        assert(data.count == 3) // @ROBUSTNESS: expects data array to have exactly 3 values
        var result = [Bool](repeating: false, count: 5)
        result[0] = false
        result[4] = false
        for (i, value) in data.enumerated() {
            switch (value) {
            case .open:   result[i+1] = true
            case .closed: result[i+1] = false
            }
        }
        return result
    }
    
    private func createLine(from: CGPoint,
                            to: CGPoint,
                            color: SKColor,
                            width: CGFloat = 2.0) -> SKShapeNode {
        let node = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        node.path = path.cgPath
        node.strokeColor = color
        node.lineWidth = width
        return node
    }
    
    // @NOTE: interesting, when you put a member variable
    // directly about the only function that uses it.
    // Functions have this space where they can store
    // information indefinitely.  You can leave it, or do
    // things like update it once per frame.  No longer
    // have to look at two different spots.
    // This is fragile, but the form reflects that,
    // this is ugly, like a growth that raises of the top
    // and when it gets bigger it looks unstable.
    private let fadeCutoff: Double = 0.2 // this is a constant, so not as useful as a var
    func getFadeAmount(y: Double) -> CGFloat { // also this is a weird spot for this
        if y < self.layout.spawnPosition { return 0.0 }
        if y > self.layout.destroyPosition { return 0.0 }
        
        if y < self.layout.spawnPosition + fadeCutoff {
            let t = ((self.layout.spawnPosition + fadeCutoff) - y) / fadeCutoff
            return CGFloat(lerp(t, min: 1.0, max: 0.0))
        }
        
        if y > self.layout.destroyPosition - fadeCutoff {
            let t = (y - (self.layout.destroyPosition - fadeCutoff)) / fadeCutoff
            return CGFloat(lerp(t, min: 1.0, max: 0.0))
        }
        
        return 1.0
    }
}
