
#include <stdio.h>
#include <stdlib.h>

#include "render.h"
#include "gl.h"

void renderer_init(Renderer* renderer) {
    renderer->playerPosition = 0.0f;
}

void renderer_free(Renderer* renderer) {
    renderer_init(renderer);
}

void render(Renderer* renderer, MessageQueue* logic_queue) {
    glClearColor(1.0f, 0.5f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    for (int i = 0; i < logic_queue->count; i++) {
        // for each message, update renderer's internal state
        Message message;
        dequeue_message(logic_queue, &message);
        switch (message.type) {
            case (ROUND_START):
                glClearColor(1.0f, 0.5f, 0.0f, 1.0f);
                glClear(GL_COLOR_BUFFER_BIT);
                break;
            case (INPUT_LEFT):
                glClearColor(1.0f, 0.0f, 0.0f, 1.0f);
                glClear(GL_COLOR_BUFFER_BIT);
                break;
            case (INPUT_RIGHT):
                glClearColor(0.0f, 0.0f, 1.0f, 1.0f);
                glClear(GL_COLOR_BUFFER_BIT);
                break;
            default:
                break; /*nop*/
        }
    }
}
