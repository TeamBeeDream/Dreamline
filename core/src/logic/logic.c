#include <stdlib.h>

#include "logic.h"

GameState* game_state_init(void) {
    GameState* state = (GameState*)malloc(sizeof(GameState));
    return state;
}

void game_state_free(GameState* state) {
    free(state);
}

// state, in_queue, out_queue
void game_state_update(GameState* state, MessageQueue* input_queue, MessageQueue* output_queue) {
    // dequeue all input messages
    // update all game entities (pass message queue)
    // clean up 'dead' entities
    
    // temp: copy all messages to output queue
    for (int i = 0; i < input_queue->count; i++) {
        Message message;
        dequeue_message(input_queue, &message);
        enqueue_message(output_queue, message.type);
    }
}
