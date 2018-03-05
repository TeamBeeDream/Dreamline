#ifndef config_h
#define config_h

#ifdef __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_OS_IPHONE
        #define VIEWPORT_W 640
        #define VIEWPORT_H 1136
    #elif TARGET_IPHONE_SIMULATOR
    #elif TARGET_OS_MAC
        #define DEV
        #define VIEWPORT_W 320
        #define VIEWPORT_H 568
    #endif
#else
    #error "Unsupported platform"
#endif

#endif
