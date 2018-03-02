#include <stdio.h>

#include "dev.h"

#include "logic/logic.h"
#include "logic/messages.h"
#include "graphics/render.h"

// GLOBAL test stuff
MessageQueue input_queue;
MessageQueue output_queue;
GameState* model;

void controller_update();

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
    dev_loop(demo_scene);
    dev_quit();

    // free memory
    game_state_free(model);
    message_queue_free(&input_queue);
    message_queue_free(&output_queue);
    return 0;
}

// TODO: move to its own file
void controller_update() {
    game_state_update(model, &input_queue, &output_queue);

    // steps:
    // - add input to model queue
    // - update model
    // - get all messages from the model
    // - send messages to render queue
    // - render
    // - repeat
}
