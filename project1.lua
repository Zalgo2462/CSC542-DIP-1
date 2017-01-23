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
local il = require "il"
local pProc = require "pointProc"
-----------
-- menus --
-----------

imageMenu("Point processes", {
    {"Brighten", pProc.brighten, {{name = "amount", type = "number", displaytype = "spin", default = 0, min = -255, max = 255}}},
    {"Greyscale", pProc.greyscale},
    {"Negate", pProc.negate},
    {"Threshold", pProc.threshold, {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
    {"Contrast Stretch", pProc.contrastStretch, {{name = "rangeStart", type = "number", displaytype = "slider", default = 0, min = 0, max = 255},
        {name = "rangeEnd", type = "number", displaytype = "slider", default = 255, min = 0, max = 255}}},
})

--imageMenu("Histogram processes", {})

start()
