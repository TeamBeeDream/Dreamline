//
//  TestController.swift
//  Dreamline
//
//  Created by BeeDream on 3/2/18.
//  Copyright © 2018 BeeDream. All rights reserved.
//

import Foundation

class TestController {

    var player_input: Float = 0.0
    var player_input_pressed = false
    var player_input_count = 0

    var inputQueue = UnsafeMutablePointer<MessageQueue>.allocate(capacity: 1)
    var renderer = UnsafeMutablePointer<Renderer>.allocate(capacity: 1)

    init() {
        message_queue_init(inputQueue)
        renderer_init(renderer)
    }
    
    func mainLoop() {
        // process input
        message_queue_free(inputQueue)
        if player_input != 0.0 {
            enqueue_message(inputQueue, player_input < 0 ? INPUT_LEFT : INPUT_RIGHT)
        }
        player_input = 0.0
        player_input_pressed = false

        // update game loop
        // @TODO

        // render
        render(renderer, inputQueue)
    }
    
    func addInput(input: Float) {
        player_input = input
        player_input_pressed = true
        player_input_count += 1
    }
    
    func removeInput() {
        player_input_count -= 1
    }
}
