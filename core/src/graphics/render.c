
#include <stdio.h>
#include <stdlib.h>

#include "../common/config.h"
#include "render.h"
#include "gl.h"

#include "shaders/basic_shader.h"

float vertices[] = {
    -0.5f, -0.5f, 0.0f,
     0.5f, -0.5f, 0.0f,
     0.0f,  0.5f, 0.0f
};

unsigned int VBO;
unsigned int VAO;
unsigned int vertex_shader;
unsigned int fragment_shader;
unsigned int shader_program;

void check_shader(unsigned int shader) {
    int success;
    char infoLog[512];

    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

    if (!success) {
        glGetShaderInfoLog(shader, 512, NULL, infoLog);
        printf("ERROR::SHADER::VERTEX::COMPILATION_FAILED\n%s\n", infoLog);
    }
}

void check_program(unsigned int program) {
    int success;
    char infoLog[512];

    glGetProgramiv(program, GL_LINK_STATUS, &success);

    if (!success) {
        glGetProgramInfoLog(program, 512, NULL, infoLog);
        printf("ERROR::PROGRAM::LINK_FAILED\n%s\n", infoLog);
    }
}

void renderer_init(Renderer* renderer) {
    renderer->playerPosition = 0.0f;

    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);

    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);

    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);

    vertex_shader = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex_shader, 1, &basic_shader_vert, NULL);
    glCompileShader(vertex_shader);
    check_shader(vertex_shader);

    fragment_shader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment_shader, 1, &basic_shader_frag, NULL);
    glCompileShader(fragment_shader);
    check_shader(fragment_shader);

    shader_program = glCreateProgram();
    glAttachShader(shader_program, vertex_shader);
    glAttachShader(shader_program, fragment_shader);
    glLinkProgram(shader_program);
    check_program(shader_program);
}

void renderer_free(Renderer* renderer) {
    renderer_init(renderer); // @FIXME, init will recompile all the shader stuff, not what we want

    glDeleteShader(vertex_shader);
    glDeleteShader(fragment_shader);
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

    // ACTUAL RENDER STUFF vvvv

    glViewport(0, 0, VIEWPORT_W, VIEWPORT_H);
    glUseProgram(shader_program);
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    // ACTUAL RENDER STUFF ^^^^
}
