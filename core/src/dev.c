#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

#include "dev.h"
#include "common/messages.h"
#include "logic/logic.h"
#include "graphics/gl.h"
#include "graphics/render.h"

void dev_init(void);
void dev_loop(void);
void dev_quit(void);

void error_callback(int error, const char* description);
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods);

void run_dev(void) {
    dev_init();
    dev_loop();
    dev_quit();
}

// GLOBAL: watch out!
GLFWwindow* devWindow;
void (*custom_key_callback)(int, int);

float player_input = 0.0f;
bool player_input_pressed = false;

MessageQueue input_queue;

Renderer renderer;

// @TODO: Tuck glfw code away.
void dev_init(void) {
    if (!glfwInit()) {
        fprintf(stderr, "Failed to init GLFW!\n");
        exit(0);
    }
    
    glfwSetErrorCallback(error_callback);
    
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
    
    devWindow = glfwCreateWindow(VIEWPORT_W, VIEWPORT_H, "iPhone", NULL, NULL);
    if (!devWindow) {
        printf("Failed to open GLFW window!\n");
        return;
    }

    glfwMakeContextCurrent(devWindow);
    glfwSetKeyCallback(devWindow, key_callback);

    // GLAD
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        printf("Failed to init GLAD\n");
        return;
    }

    // init stuff
    message_queue_init(&input_queue);
    renderer_init(&renderer);
}

void dev_loop(void) {
    glfwSetKeyCallback(devWindow, key_callback);

    while (!glfwWindowShouldClose(devWindow)) {

        // MAIN UPDATE LOOP //
        
        // 1) handle input
        message_queue_free(&input_queue);
        if (player_input_pressed) {
            MessageType input = (player_input < 0.0f) ? INPUT_LEFT : INPUT_RIGHT;
            enqueue_message(&input_queue, input);
        }

        // 2) update game model
        // @TODO

        // 3) render scene
        render(&renderer, &input_queue);

        glfwSwapBuffers(devWindow);
        glfwPollEvents();
    }
}

void dev_quit(void) {
    glfwDestroyWindow(devWindow);
    glfwTerminate();
}

void error_callback(int error, const char* description) {
    fprintf(stderr, "Error: %s\n", description);
}


// INPUT
// in the actual game, input is passed through events
// and will be added to the input queue

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    // quit
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GLFW_TRUE);
    }
    
    // player input
    if (key == GLFW_KEY_LEFT && action == GLFW_PRESS) {
        player_input = -1.0f;
        player_input_pressed = true;
    } else if (key == GLFW_KEY_RIGHT && action == GLFW_PRESS) {
        player_input = 1.0f;
        player_input_pressed = true;
    } else {
        player_input = 0.0f;
        player_input_pressed = false;
    }
}
