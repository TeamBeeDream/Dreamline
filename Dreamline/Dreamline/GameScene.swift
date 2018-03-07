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
    
    // @TODO: move model stuff to controller
    var model: GameModel = DefaultGameModel()
    var state: ModelState = ModelState.getDefault()
    
    // TEMP
    var previousTime: TimeInterval = 0
    var tmpPlayerNode = SKShapeNode()
    var barrierNodes = [SKNode]()
    var fadeCutoff = 0.175
    var numInputs: Int = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.darkGray
        
        let radius = CGFloat(state.positionerState.tolerance) * frame.width / 4.0
        let playerGraphic = SKShapeNode(circleOfRadius: radius)
        playerGraphic.lineWidth = 0
        playerGraphic.fillColor = SKColor.red
        self.tmpPlayerNode = playerGraphic
        addChild(self.tmpPlayerNode)
        self.tmpPlayerNode.position = point(x: 0.0, y: state.boardLayout.playerPosition)
        
        // debug
        drawLayoutLines(layout: state.boardLayout)
    }
    
    private func drawLayoutLines(layout: BoardLayout) {
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
        let convertedX = frame.midX + (x * frame.width / 2.0)
        let convertedY = frame.midY - (y * frame.height / 2.0)
        return CGPoint(x: convertedX, y: convertedY)
    }
    
    // @TODO: move to user input class
    private func addInput(_ lane: Int) {
        state.targetOffset = Double(lane)
        self.numInputs += 1
    }
    
    // @TODO: move to user input class
    private func removeInput(count: Int) {
        self.numInputs -= count
        if (self.numInputs == 0) {
            state.targetOffset = 0.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in: self.view)
            if position.x < self.frame.midX {
                self.addInput(Lane.left.rawValue)
            } else {
                self.addInput(Lane.right.rawValue)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeInput(count: touches.count)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeInput(count: touches.count)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        // @TODO: handle events from update
        let (updatedState, _) = model.update(state: state, dt: dt)
        self.state = updatedState
        
        let position = state.positioner.getPosition(state: state.positionerState)
        let offset = CGFloat(position.offset * state.boardLayout.laneOffset)
        self.tmpPlayerNode.position.x = point(x: offset, y: 0.0).x
        self.tmpPlayerNode.fillColor = position.withinTolerance ? SKColor.green : SKColor.white
        
        // @HACK
        self.drawBarriers(gridState: state.boardState)
    }
    
    // @TODO: move to separate class (in graphics folder)
    private func createBarrierGraphic(barrier: Barrier) -> SKNode {
        // @CLEANUP, this code is hard to understand
        let occupied = CGFloat(1.0 - state.boardLayout.laneOffset * 2)
        let margin = (frame.width * occupied) / 2.0
        let width = frame.width - (margin * 2.0)
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
    
    private func getFadeAmount(y: Double) -> CGFloat {
        if y < state.boardLayout.spawnPosition { return 0.0 }
        if y > state.boardLayout.destroyPosition { return 0.0 }
        
        if y < state.boardLayout.spawnPosition + fadeCutoff {
            let t = ((state.boardLayout.spawnPosition + fadeCutoff) - y) / fadeCutoff
            return CGFloat(lerp(t, min: 1.0, max: 0.0))
        }
        
        if y > state.boardLayout.destroyPosition - fadeCutoff {
            let t = (y - (state.boardLayout.destroyPosition - fadeCutoff)) / fadeCutoff
            return CGFloat(lerp(t, min: 1.0, max: 0.0))
        }
        
        return 1.0
    }
    
    // @TODO: move to other class
    private func drawBarriers(gridState: BoardState) {
        self.clearBarriers()
        
        for (_, barrier) in gridState.barriers.enumerated() {
            let node = self.createBarrierGraphic(barrier: barrier)
            node.position.y = point(x: 0.0, y: barrier.position).y
            node.alpha = getFadeAmount(y: barrier.position)
            self.barrierNodes.append(node)
            addChild(node)
        }
    }
    
    private func clearBarriers() {
        for node in self.barrierNodes {
            node.removeFromParent()
        }
        
        self.barrierNodes.removeAll()
    }
}
