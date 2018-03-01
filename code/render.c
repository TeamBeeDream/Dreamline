
#include <stdio.h>
#include <stdlib.h>

#include "render.h"
#include "gl.h"

void test_capabilities(void) {
   if (!glfwInit()) {
        fprintf(stderr, "Failed to init GLFW\n");
        return;
   } else {
        printf("init GLFW!\n");
   }

   glfwWindowHint(GLFW_SAMPLES, 4);
   glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
   glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
   glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
   glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

   GLFWwindow* window;
   window = glfwCreateWindow(1024, 768, "iPhone Sim", NULL, NULL);
   if (window == NULL) {
       fprintf(stderr, "Failed to open GLFW window.\n");
       glfwTerminate();
       return;
   }

   glfwMakeContextCurrent(window);

   glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE);
    do {
        glfwSwapBuffers(window);
        glfwPollEvents();
    } while (glfwGetKey(window, GLFW_KEY_ESCAPE) != GLFW_PRESS &&
            glfwWindowShouldClose(window) == 0);
}

void test_render(void) {
    printf("this is being printed from render.c\n");
    //glClear(GL_COLOR_BUFFER_BIT);
    //glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
}
