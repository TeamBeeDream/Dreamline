#ifndef basic_shader_h
#define basic_shader_h

const char* basic_shader_vert = "\n"
"attribute vec4 position;\n"
"void main() {\n"
"   gl_Position = position;\n"
"}\n\0";

const char* basic_shader_frag = "\n"
"void main() {\n"
"   gl_FragColor = vec4(1.0, 0.05, 0.2, 1.0);\n"
"}\n\0";

#endif
