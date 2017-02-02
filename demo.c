#include <lua.h>

char* demo_hello(void) {
    return "This string is from the actual C module";
}

int lua_demo_hello(lua_State *L) {
    lua_pushstring(L,demo_hello());
    return 1;
}

int luaopen_demo_core(lua_State *L) {
    lua_pushcfunction(L,lua_demo_hello);
    return 1;
}
