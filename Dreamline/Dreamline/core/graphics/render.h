#ifndef render_h
#define render_h

#include "../common/messages.h"

typedef struct {
    float playerPosition;
} Renderer;

void renderer_init(Renderer* renderer);
void renderer_free(Renderer* renderer);

void render(Renderer* render, MessageQueue* logic_queue);

#endif
