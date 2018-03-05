TARGET = program
LIBS = -lm -framework OpenGL -lGLFW -I/usr/local/include
CC = gcc
CFLAGS = -g -Wall

SRC_DIR = ./src
BIN_DIR = ./bin
APP_DIR = ./bin/core

.PHONY: default all clean

default: $(TARGET)
all: default

# all *.c files in src folder
SOURCES = $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*/*.c)
HEADERS = $(wildcard $(SRC_DIR)/*/*.h)
OBJECTS = $(patsubst %.c, %.o, $(SOURCES))

# rule for objects: auto compile with $(CC)
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

# main build rule
$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall $(LIBS) -o $(BIN_DIR)/$@

# clean rule
clean:
	-rm -f $(SRC_DIR)/*.o
	-rm -f $(SRC_DIR)/*/*.o
	-rm -rf $(BIN_DIR)/*

# basic run rule
run: $(TARGET)
	$(BIN_DIR)/$(TARGET)

# export files for xcode
export: $(TARGET)
	-mkdir -p $(APP_DIR)
	-rm -rf $(APP_DIR)/*
	-cp -R $(SRC_DIR)/* $(APP_DIR)/
	-rm -f $(APP_DIR)/*.*
	-rm -f $(APP_DIR)/*/*.o
