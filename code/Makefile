TARGET = run
LIBS = -lm -framework OpenGL -lGLFW
CC = gcc
CFLAGS = -g -Wall

SRC_DIR = ./src
BIN_DIR = ./bin
APP_DIR = ../Dreamline/Dreamline/c_code	# this folder is in the xcode project

.PHONY: default all clean

default: $(TARGET)		# by default, "make" becomes "make $(TARGET)"
all: default			# do $(TARGET) command every time

SOURCES = $(wildcard $(SRC_DIR)/*.c)		# all *.c files in src folder
HEADERS = $(wildcard %(SRC_DIR)/*.h)		# all *.h files in src folder
OBJECTS = $(patsubst %.c, %.o, $(SOURCES)) 	# *.c compiled to *.o in place

# rule for objects: auto compile with $(CC)
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS) # don't delete intermediate files

# main build rule
$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall $(LIBS) -o $(BIN_DIR)/$@	# build final $(TARGET)
	-rm -f $(SRC_DIR)/*.o							# cleanup *.o files

# clean rule
clean:
	-rm -f $(SRC_DIR)/*.o	# cleanup *.o files in src folder
	-rm -f $(BIN_DIR)/*		# cleanup all files in bin folder

# basic run rule
run: $(TARGET)
	$(BIN_DIR)/$(TARGET)	# launch executable

# export source files to xcode project
export: $(TARGET)
	-rm -f $(APP_DIR)/*					# clear destination folder
	-cp -R $(SRC_DIR)/* $(APP_DIR)/		# copy all files/folders to destination folder
