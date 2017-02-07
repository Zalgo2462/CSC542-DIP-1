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
    {"Contrast Stretch", pProc.contrastStretch, {
        {name = "rangeStart", type = "number", displaytype = "slider", default = 0, min = 0, max = 255},
        {name = "rangeEnd", type = "number", displaytype = "slider", default = 255, min = 0, max = 255}}},
    {"Auto Contrast Stretch", pProc.autoContrastStretch},
    {"Percentage Contrast Stretch", pProc.percentageContrastStretch, {
        {name = "lowPercent", type = "number", displaytype = "spin", default = 1, min = 0, max = 100},
        {name = "highPercent", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}}},
    {"Gamma", pProc.gamma, {{name = "gamma", type = "number", displaytype = "textbox", default = 1, min = 0, max = 25}}},
    {"Log", pProc.log},
    {"Bit-Plane Slice", pProc.bitPlaneSlice, {{name = "bit", type = "number", displaytype = "spin", default = 1, min = 1, max = 8}}},
    {"Display Histogram", il.showHistogram},
    {"Histogram Equalization", pProc.histogramEqualization},
    {"Clipped Histogram Equalization", pProc.clippedHistogramEqualization, {{name="clip percent", type = "number", displaytype = "textbox", default = 1}}},
    {"Histogram Equalize Clip", il.equalizeClip,
      {{name = "clip %", type = "number", displaytype = "textbox", default = 1.0},
       {name = "color model", type = "string", default = "yiq"}}},
    {"Posterize", pProc.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"8 Pseudocolor", pProc.pseudo8},
    {"Continuous Pseudocolor", pProc.pseudo},
  })

--imageMenu("Histogram processes", {})

start()
