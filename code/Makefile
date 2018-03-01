TARGET = prog
LIBS = -lm -framework OpenGL -lGLFW
CC = gcc
CFLAGS = -g -Wall
SRC_DIR = ./src
BIN_DIR = ./bin

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard $(SRC_DIR)/*.c)) # .c files compiled in place
HEADERS = $(wildcard %(SRC_DIR)/*.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS) # I'm not sure what this does.

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall $(LIBS) -o $(BIN_DIR)/$@

clean:
	-rm -f $(SRC_DIR)/*.o
	-rm -f $(BIN_DIR)/*

run: $(TARGET)
	$(BIN_DIR)/$(TARGET)
