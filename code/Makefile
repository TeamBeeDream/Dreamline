TARGET = program
LIBS = -lm -framework OpenGL -lGLFW
CC = gcc
CFLAGS = -g -Wall

SRC_DIR = ./src
BIN_DIR = ./bin
#APP_DIR = ../Dreamline/Dreamline/c_code
APP_DIR = ./bin/c_code

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
	-rm -f $(SRC_DIR)/*.o

# clean rule
clean:
	-rm -f $(SRC_DIR)/*.o
	-rm -f $(SRC_DIR)/*/*.o
	-rm -rf $(BIN_DIR)/*

# basic run rule
run: $(TARGET)
	$(BIN_DIR)/$(TARGET)

# export source files to xcode project
export: $(TARGET)
	-mkdir -p $(APP_DIR)
	-rm -rf $(APP_DIR)/*
	-cp -R $(SRC_DIR)/* $(APP_DIR)/
	
	-rm -f $(wildcard $(APP_DIR)/*.*)
	-rm -rf $(APP_DIR)/*/*.o
