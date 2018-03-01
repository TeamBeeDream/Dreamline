#ifndef config_h
#define config_h

#ifdef __APPLE__
    #include "TargetConditionals.h"
    #if TARGET_OS_IPHONE
    #elif TARGET_IPHONE_SIMULATOR
    #elif TARGET_OS_MAC
        #define DEV
    #endif
#else
    #error "Unsupported platform"
#endif

#endif
