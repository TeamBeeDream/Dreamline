//
//  ConfiguratorTests.swift
//  DreamlineTests
//
//  Created by BeeDream on 3/29/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import XCTest
@testable import Dreamline

class DefaultConfiguratorTests: XCTestCase {
    
    // MARK: Test Variables
    
    private var configurator: Configurator!
    private var config: GameConfig!
    private var ruleset: Ruleset!
    
    // MARK: XCTestCase Methods
    
    override func setUp() {
        self.configurator = DefaultConfigurator.make()
        self.config = GameConfigFactory.getMock()
        self.ruleset = RulesetFactory.getMock()
    }
    
    // MARK: Tests
    
    func testUpdateConfig_NoEvents() {
        let events = [Event]()
        let config = self.configurator.updateConfig(config: self.config,
                                                    ruleset: self.ruleset,
                                                    events: events)
        XCTAssert(config.boardScrollSpeed == self.config.boardScrollSpeed)
    }
    
    func testUpdateConfig_ModifierNone() {
        let events = [Event.modifierGet(0, ModifierType.none)]
        let config = self.configurator.updateConfig(config: self.config,
                                                    ruleset: self.ruleset,
                                                    events: events)
        XCTAssert(config.boardScrollSpeed == self.config.boardScrollSpeed)
    }
    
    func testUpdateConfigModifier_ModifierSpeedUp() {
        let events = [Event.modifierGet(0, ModifierType.speedUp)]
        let config = self.configurator.updateConfig(config: self.config,
                                                    ruleset: self.ruleset,
                                                    events: events)
        XCTAssert(config.boardScrollSpeed != self.config.boardScrollSpeed)
    }
    
    func testUpdateConfigModifier_ModifierSpeedDown() {
        let events = [Event.modifierGet(0, .speedDown)]
        let config = self.configurator.updateConfig(config: self.config,
                                                    ruleset: self.ruleset,
                                                    events: events)
        XCTAssert(config.boardScrollSpeed == self.config.boardScrollSpeed)
    }
}
