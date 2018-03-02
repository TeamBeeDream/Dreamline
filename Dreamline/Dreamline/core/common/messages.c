#include <stdlib.h>
#include <assert.h>

#include "memory.h"
#include "messages.h"

void message_queue_init(MessageQueue* queue) {
    //MessageQueue* message_queue = (MessageQueue*)malloc(sizeof(MessageQueue));
    queue->capacity = 0;
    queue->count = 0;
    queue->messages = NULL;
    //return message_queue;
}

void message_queue_free(MessageQueue* queue) {
    FREE_ARRAY(Message, queue->messages, queue->capacity);
    message_queue_init(queue);
    //free(queue);
}

void enqueue_message(MessageQueue* queue, MessageType type) {
    if (queue->capacity < queue->count + 1) {
        int oldCapacity = queue->capacity;
        queue->capacity = GROW_CAPACITY(oldCapacity);
        queue->messages = GROW_ARRAY(queue->messages, Message, oldCapacity, queue->capacity);
    }
    Message* message = (Message*)malloc(sizeof(Message));
    message->type = type;
    queue->messages[queue->count] = *message;
    queue->count++;
}

void dequeue_message(MessageQueue* queue, Message* message) {
    assert(queue->count > 0);
    message->type = queue->messages[queue->count - 1].type;
    //free(&queue->messages[queue->count - 1]); // does this work?
    queue->count--;
}
