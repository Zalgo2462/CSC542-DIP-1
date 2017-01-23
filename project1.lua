--[[

  * * * * lip.lua * * * *

Lua image processing program: exercise all LuaIP library routines.

Authors: John Weiss and Alex Iverson
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

-- LuaIP image processing routines
require "ip"   -- this loads the packed distributable
local viz = require "visual"
local pProc = require "pointProc"
-----------
-- menus --
-----------

imageMenu("Point processes", {
    {"Brighten", pProc.brighten},
    {"Greyscale", pProc.greyscale},
    {"Negate", pProc.negate}
})

--imageMenu("Histogram processes", {})

start()
