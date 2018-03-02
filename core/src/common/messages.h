#ifndef messages_h
#define messages_h

typedef enum {
    // LOGIC
    ROUND_START,
    ROUND_COMPLETE,

    // INPUT
    INPUT_LEFT,
    INPUT_RIGHT,

    // RENDERING
    PLAYER_ADDED,   
} MessageType;

typedef struct {
    MessageType type;
} Message;

typedef struct {
    int capacity;
    int count;
    Message* messages;
} MessageQueue;

void message_queue_init(MessageQueue* queue);
void message_queue_free(MessageQueue* queue);

void enqueue_message(MessageQueue* queue, MessageType type);
void dequeue_message(MessageQueue* queue, Message* message);

// @TODO: make queue behave more like a ring buffer
// right now it behaves more like a stack

#endif
