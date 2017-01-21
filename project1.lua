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

-----------
-- menus --
-----------

imageMenu("Point processes", {})

imageMenu("Histogram processes", {})

start()
