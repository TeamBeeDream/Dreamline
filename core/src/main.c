#include <stdio.h>

#include "dev.h"
#include "graphics/render.h"

int main(int argc, const char* argv[]) {
    dev_init();
    dev_loop(demo_scene);
    dev_quit();
    return 0;
}
