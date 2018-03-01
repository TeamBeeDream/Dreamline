//
//  gl_test.c
//  Dreamline
//
//  Created by BeeDream on 3/1/18.
//  Copyright © 2018 BeeDream. All rights reserved.
//

#include "gl_test.h"
#include <OpenGLES/ES2/gl.h>

void render(void) {
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f); // test color
    glClear(GL_COLOR_BUFFER_BIT);
}
