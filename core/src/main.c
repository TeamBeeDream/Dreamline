#include <stdio.h>

#include "dev.h"

#include "logic/logic.h"
#include "logic/messages.h"
#include "graphics/render.h"
#include "graphics/gl.h"

// GLOBAL test stuff
MessageQueue input_queue;
MessageQueue output_queue;
GameState* model;

void controller_update();
void handle_input(int key, int action);

int main(int argc, const char* argv[]) {

    // create game state
    message_queue_init(&input_queue);
    message_queue_init(&output_queue);
    model = game_state_init();

    // temp message queue stuff
    /*
    MessageType type = ROUND_COMPLETE;
    Message message;
    enqueue_message(queue, type);
    dequeue_message(queue, &message);
    printf("original: %i\n", type);
    printf("message: %i\n", message.type);
    */

    // main loop
    dev_init();
    controller_update();
    dev_loop(controller_update, handle_input);
    dev_quit();

    // free memory
    game_state_free(model);
    message_queue_free(&input_queue);
    message_queue_free(&output_queue);
    return 0;
}

// GLOBAL, temp input stuff
float current_input = 0.0f;

void handle_input(int key, int action) {
    if (key == GLFW_KEY_LEFT && action == GLFW_PRESS) {
        current_input = -1.0f;
    } else if (key == GLFW_KEY_RIGHT && action == GLFW_PRESS) {
        current_input = 1.0f;
    } else {
        current_input = 0.0f;
    }
}

// TODO: move to its own file
void controller_update() {
    // get input from user
    message_queue_free(&input_queue); // @TODO: replace with clear function
    if (current_input != 0.0f) {
        enqueue_message(&input_queue, current_input < 0.0f ? INPUT_LEFT : INPUT_RIGHT);
    }

    // update game state
    game_state_update(model, &input_queue, &output_queue);

    // render
    render(&output_queue);

    // steps:
    // - add input to model queue
    // - update model
    // - get all messages from the model
    // - send messages to render queue
    // - render
    // - repeat
}
