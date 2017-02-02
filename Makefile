CC = gcc
AR = ar
RANLIB = ranlib
LUA = lua
LUA_LIBS = $(shell pkg-config --libs $(LUA))
LUA_CFLAGS = $(shell pkg-config --cflags $(LUA))

.PHONY: all clean
.SUFFIXES:

all: demo/core.a demo/core.so

demo.o: demo.c
	$(CC) -Wall -Wextra -fPIC $(LUA_CFLAGS) -c demo.c -o demo.o

demo/core.a: demo.o
	mkdir -p demo
	$(AR) rcs demo/core.a demo.o
	$(RANLIB) demo/core.a

demo/core.so: demo.o
	mkdir -p demo
	$(CC) -shared $(LUA_LIBS) -o demo/core.so demo.o

clean:
	rm -f demo/core.a demo/core.so demo.o 
	rmdir demo
