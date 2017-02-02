local modname = { 'demo','core'}
local concat = table.concat
local ok, ffi = pcall(require,'ffi')

if not ok then -- we must be in regular Lua, just use normal C module
    local demo_hello = require(concat(modname,'.'))
    return function()
      return 'This is using the C API\n' .. demo_hello()
    end
end

local demo_hello -- save reference to function

ffi.cdef[[
char* demo_hello(void);
]]

pcall(function()
  if ffi.C.demo_hello then -- we're in a static binary, already linked, etc
      demo_hello = ffi.C.demo_hello
  end
end)

if not demo_hello then -- module not already linked, try to find and open dynamically
  local dir_sep, sep, sub
  local gmatch = string.gmatch
  local match = string.match
  local open = io.open
  local close = io.close

  for m in gmatch(package.config, '[^\n]+') do
      local m = m:gsub('([^%w])','%%%1')
      if not dir_sep then dir_sep = m
          elseif not sep then sep = m
          elseif not sub then sub = m end
  end

  local function find_lib(name)
    for m in gmatch(package.cpath, '[^' .. sep ..';]+') do
        local so_path, r = m:gsub(sub,name)
        if(r > 0) then
            local f = open(so_path)
            if f ~= nil then
                close(f)
                return so_path
            end
        end
    end
  end

  local function load_lib()
     local so_path = find_lib(concat(modname,dir_sep))
     if so_path then
         return ffi.load(so_path)
     end
  end

  local lib = load_lib()
  if lib then -- found the library, return the function reference
    demo_hello = lib.demo_hello
  end
end

if not demo_hello then
  return nil,'failed to load module'
end

-- now we return the real guts of the module
return function()
  return 'This is using the FFI API\n' .. ffi.string(demo_hello())
end
