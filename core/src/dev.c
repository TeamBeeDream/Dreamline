#include <stdlib.h>
#include <stdio.h>

#include "dev.h"
#include "graphics/gl.h"

void error_callback(int error, const char* description);
void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods);

// GLOBAL: watch out!
GLFWwindow* devWindow;
void (*custom_key_callback)(int, int);

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
    
    devWindow = glfwCreateWindow(320, 568, "iPhone", NULL, NULL);
    if (!devWindow) {
        printf("Failed to open GLFW window!\n");
        return;
    }

    glfwMakeContextCurrent(devWindow);
    glfwSetKeyCallback(devWindow, key_callback);
}

// @TODO: rename all these key_callback functions,
// @TODO: typedef function signatures
void dev_loop(void (*update)(void), void (*given_key_callback)(int key, int action)) {
    custom_key_callback = given_key_callback;
    glfwSetKeyCallback(devWindow, key_callback);

    while (!glfwWindowShouldClose(devWindow)) {
        update(); // @TODO: figure out if this should be before or after pollevents()

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

void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GLFW_TRUE);
    }

    custom_key_callback(key, action);
}
