//
//  GameScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // TEMP
    var previousTime: TimeInterval = 0
    var tmpPlayerNode = SKShapeNode()
    let tmpVertPos: CGFloat = 0.25 // @FIXME @HARDCODED
    let tmpHoriOffset: CGFloat = 0.35
    let model: GameModel = DebugGameModel()
    var barrierNodes = [SKNode]()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.darkGray
        
        let playerGraphic = SKShapeNode(circleOfRadius: 16)
        playerGraphic.lineWidth = 0
        playerGraphic.fillColor = SKColor.red
        self.tmpPlayerNode = playerGraphic
        addChild(self.tmpPlayerNode)
        self.tmpPlayerNode.position = CGPoint(x: self.frame.midX, y: self.frame.maxY * self.tmpVertPos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in: self.view)
            if position.x < self.frame.midX {
                self.model.addInput(Lane.left.rawValue)
            } else {
                self.model.addInput(Lane.right.rawValue)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.removeInput(count: touches.count) // woah
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.removeInput(count: touches.count) // woah
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        self.model.update(dt: dt)
        
        let position = self.model.getPosition()
        let offset = CGFloat(position.offset) * (tmpHoriOffset * frame.width)
        self.tmpPlayerNode.position.x = self.frame.midX + offset
        self.tmpPlayerNode.fillColor = position.withinTolerance ? SKColor.green : SKColor.white
        
        // @HACK
        self.drawBarriers(gridState: self.model.getBarriers())
    }
    
    // @TODO: move to separate class (in graphics folder)
    private func createBarrierGraphic(barrier: Barrier) -> SKNode {
        
        let margin = frame.width * (1.0 - (tmpHoriOffset * 4)) / 2.0
        let width = frame.width - (margin * 2.0)
        let gateWidth = Double(width / 4.0)
        let gateHeight = 20.0 // @HARDCODED
        let wallY: Double = 0
        
        let barrierGraphic = SKNode()
        let wallColor = self.wallColor(barrier.state)
        let gateColor = self.gateColor(barrier.state)
        
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
            }
            if !prev {
                let wall = self.createLine(from: CGPoint(x: prevX, y: wallY),
                                           to: CGPoint(x: midX, y: wallY),
                                           color: wallColor)
                barrierGraphic.addChild(wall)
            }
            if !curr {
                let wall = self.createLine(from: CGPoint(x: midX, y: wallY),
                                           to: CGPoint(x: currX, y: wallY),
                                           color: wallColor)
                barrierGraphic.addChild(wall)
            }
        }
        let wallL = self.createLine(from: CGPoint(x: Double(frame.minX), y: wallY),
                                   to: CGPoint(x: frame.minX + margin, y: CGFloat(wallY)),
                                   color: wallColor)
        barrierGraphic.addChild(wallL)
        let wallR = self.createLine(from: CGPoint(x: Double(frame.maxX), y: wallY),
                                    to: CGPoint(x: frame.maxX - margin, y: CGFloat(wallY)),
                                    color: wallColor)
        barrierGraphic.addChild(wallR)
        
        return barrierGraphic
    }
    
    private func wallColor(_ state: BarrierState) -> SKColor {
        switch (state) {
        case .idle:
            return SKColor.magenta
        case .pass:
            return SKColor.green
        case .hit:
            return SKColor.red
        }
    }
    
    private func gateColor(_ state: BarrierState) -> SKColor {
        switch (state) {
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
    
    // @TODO: move to other class
    private func drawBarriers(gridState: BarrierGridState) {
        self.clearBarriers()
        
        for (_, barrier) in gridState.barriers.enumerated() {
            let node = self.createBarrierGraphic(barrier: barrier)
            node.position.y = CGFloat(posY(barrier.position))
            self.barrierNodes.append(node)
            addChild(node)
        }
    }
    
    // @TODO: make better coordinate conversion methods
    private func posY(_ pos: Double) -> Double {
        let origin = frame.height * tmpVertPos
        return Double(origin) - Double(frame.height / 2) * pos
    }
    
    private func clearBarriers() {
        for node in self.barrierNodes {
            node.removeFromParent()
        }
        
        self.barrierNodes.removeAll()
    }
}
