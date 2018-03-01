#ifndef gl_h
#define gl_h

#include "../config/config.h"

#ifdef DEV
    // OpenGL imports for local dev (OSX)
    #include <GLFW/glfw3.h>
#else
    // OpenGL imports for Xcode/iOS
    #include <OpenGLES/ES3/gl.h>
#endif

#endif
