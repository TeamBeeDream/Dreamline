//
//  RandomTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 3/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class MockConstantRandomTests: XCTestCase {
    
    // MARK: Test Variables
    
    private var random: Random!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        self.random = MockConstantRandom.make()
    }
    
    // MARK: Tests
    
    func testNext() {
        for _ in 1...100 {
            XCTAssert(self.random.next() == 0.5)
        }
    }
    
    func testNextInt() {
        for _ in 1...100 {
            XCTAssert(self.random.nextInt(min: 0, max: 2) == 1)
        }
    }
}

class MockAuthoredRandomTests: XCTestCase {
    
    // MARK: Test Variables
    
    private var random: Random!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        let sequence = [Double](repeating: 0.5, count: 100)
        self.random = MockAuthoredRandom.make(sequence: sequence)
    }
    
    // MARK: Tests
    
    func testNext() {
        for _ in 1...100 {
            XCTAssert(self.random.next() == 0.5)
        }
    }
    
    func testNextInt() {
        for _ in 1...100 {
            XCTAssert(self.random.nextInt(min: 0, max: 2) == 1)
        }
    }
}
