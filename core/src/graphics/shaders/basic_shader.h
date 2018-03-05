#ifndef basic_shader_h
#define basic_shader_h

const char* basic_shader_vert = "\n"
"#version 330 core\n"
"layout (location = 0) in vec3 aPos;\n"
"void main() {\n"
"   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
"}\n\0";

const char* basic_shader_frag = "\n"
"#version 330 core\n"
"out vec4 FragColor;\n"
"void main() {\n"
"   FragColor = vec4(1.0f, 0.05f, 0.2f, 1.0f);\n"
"}\n\0";

#endif
