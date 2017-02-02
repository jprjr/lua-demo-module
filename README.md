# lua-demo-module

This is just a silly example lua module written in C, I used this to
figure out how to create a C module that works in Lua and LuaJIT,
as well as with Lua/LuaJIT embedded into a C program.

You'll get slightly different output when using LuaJIT vs Lua, to show
whether you're using the traditional C API or the FFI API.

Files:

* demo.c - the module, compiles to 'demo/core.so' and 'demo/core.a'
* demo.lua - the loader, it will load 'demo/core.so'
* main.lua - a silly app that just uses the module

Some examples to try out:

```bash
make # builds demo/core.so and demo/core.a
lua main.lua
luajit main.lua
luastatic main.lua demo.lua /path/to/liblua.a demo/core.a -I/path/to/lua/include ; ./main
luastatic main.lua demo.lua /path/to/libluajit.a demo/core.a -I/path/to/luajit/include ; ./main
```


## LICENSE

This is in the public domain.
