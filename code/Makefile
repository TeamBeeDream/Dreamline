TARGET = prog
LIBS = -lm -framework OpenGL -lGLFW
CC = gcc
CFLAGS = -g -Wall

SRC_DIR = ./src
BIN_DIR = ./bin
APP_DIR = ../Dreamline/Dreamline/c_code

.PHONY: default all clean

default: $(TARGET)
all: default

SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst %.c, %.o, $(SOURCES)) # .c files compiled in place
HEADERS = $(wildcard %(SRC_DIR)/*.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS) # I'm not sure what this does.

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall $(LIBS) -o $(BIN_DIR)/$@
	-rm -f $(SRC_DIR)/*.o

clean:
	-rm -f $(SRC_DIR)/*.o
	-rm -f $(BIN_DIR)/*

run: $(TARGET)
	$(BIN_DIR)/$(TARGET)

export: $(TARGET)
	-rm -f $(APP_DIR)/*
	-cp -R $(SRC_DIR)/* $(APP_DIR)/
