#ifndef logic_h
#define logic_h

#include "../common/messages.h"

typedef struct {
    float playerX;
    float playerY;
} GameState;

// @TODO: message types:
// - PlayerMove { float }
// - PlayerPassGate
// - PlayerHitWall
// - RoundComplete
// - RoundStart

GameState* game_state_init(void);
void game_state_free(GameState* state);

void game_state_update(GameState* state, MessageQueue* input_queue, MessageQueue* output_queue);

#endif
