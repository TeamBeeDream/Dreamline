//
//  BarrierNode.swift
//  Dreamline
//
//  Created by BeeDream on 3/8/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

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
        
        let data = self.barrierDataToBoolArray(data: barrier.pattern)
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
