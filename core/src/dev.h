#ifndef dev_h
#define dev_h

void dev_init(void);
void dev_quit(void);

void dev_loop(
        void (*update)(void),                                // main update call
        void (*key_callback)(int key, int action)       // input call
);

#endif
