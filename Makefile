CC = gcc
AR = ar
RANLIB = ranlib
LUA = lua
LUA_LIBS = $(shell pkg-config --libs $(LUA))
LUA_CFLAGS = $(shell pkg-config --cflags $(LUA))

.PHONY: all clean
.SUFFIXES:

all: demo/core.a demo/core.so main main-static

main: main.c demo.lua.c main.lua.c
	$(CC) -Wall -Wextra -fPIC $(LUA_CFLAGS) -o main main.c $(LUA_LIBS)

main-static: main.c demo.lua.c main.lua.c demo/core.a
	$(CC) -Wall -Wextra -fPIC $(LUA_CFLAGS) -o main-static main.c -Wl,-E -Wl,--whole-archive demo/core.a -Wl,--no-whole-archive $(LUA_LIBS)

main.lua.c: main.lua
	xxd -i main.lua > main.lua.c

demo.lua.c: demo.lua
	xxd -i demo.lua > demo.lua.c

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
	rm -f demo/core.a demo/core.so demo.o demo.lua.c main.lua.c main main-static
	rmdir demo
