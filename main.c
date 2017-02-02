#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#include "demo.lua.c"
#include "main.lua.c"

int main(void) {
    printf("Initializing Lua\n");
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    int demo_res = 0;
    int main_res = 0;

    printf("Loading demo.lua into buffer\n");
    demo_res = luaL_loadbuffer(L,(const char*)demo_lua,demo_lua_len,"demo.lua");
    if(demo_res != 0) {
        printf("Buffer failed to load\n");
        printf("error: %s\n",lua_tostring(L,-1));
        return 1;
    }

    printf("Calling demo.lua\n");
    demo_res = lua_pcall(L,0,0,0);
    if(demo_res != 0) {
        printf("Error calling demo.lua\n");
        printf("error: %s\n",lua_tostring(L,-1));
        return 1;
    }

    printf("Loading main.lua into buffer\n");
    main_res = luaL_loadbuffer(L,(const char*)main_lua,main_lua_len,"main.lua");
    if(main_res != 0) {
        printf("Buffer failed to load\n");
        return 1;
    }

    printf("Calling main.lua\n");
    main_res = lua_pcall(L,0,0,0);
    if(main_res != 0) {
        printf("Error calling main.lua\n");
        printf("error: %s\n",lua_tostring(L,-1));
        return 1;
    }

    lua_close(L);
    return 0;
}
