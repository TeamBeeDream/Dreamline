//
//  InputTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 4/28/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class InputTests: XCTestCase {
    
    private var input = Input()
    
    func testLeft() {
        self.input.addInput(target: -1)
        XCTAssert(self.input.getCurrent() == -1)
    }
    
    func testRight() {
        self.input.addInput(target: 1)
        XCTAssert(self.input.getCurrent() == 1)
    }
    
    func testReturnToCenter() {
        self.input.addInput(target: 1)
        self.input.removeInput()
        XCTAssert(self.input.getCurrent() == 0)
    }
}
