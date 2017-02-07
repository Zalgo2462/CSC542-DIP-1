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
local hProc = require "histogramProc"
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
    {"Gamma", pProc.gamma, {{name = "gamma", type = "number", displaytype = "textbox", default = 1, min = 0, max = 25}}},
    {"Log", pProc.log},
    {"Bit-Plane Slice", pProc.bitPlaneSlice, {{name = "bit", type = "number", displaytype = "spin", default = 1, min = 1, max = 8}}},
    {"Display Histogram", il.showHistogram},
    {"Posterize", pProc.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"8 Pseudocolor", pProc.pseudo8},
    {"Continuous Pseudocolor", pProc.pseudo},
    {"Solarize", pProc.solarize},
    {"WS", il.solarize}
  })

imageMenu("Histogram processes", {
    {"Auto Contrast Stretch", hProc.autoContrastStretch},
    {"Percentage Contrast Stretch", hProc.percentageContrastStretch, {
        {name = "lowPercent", type = "number", displaytype = "spin", default = 1, min = 0, max = 100},
        {name = "highPercent", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}}},
    {"Histogram Equalization", hProc.histogramEqualization},
    {"Clipped Histogram Equalization", hProc.clippedHistogramEqualization, {{name="clip percent", type = "number", displaytype = "textbox", default = 1}}},
  }

)

imageMenu("Help/About",
  {
    { "Help", viz.imageMessage( "Help", "- To load an image file, click 'file' then 'open' and navigate to your image.\n"
        .. "- To perform a transformation on a loaded image, click the image, then select a transformation from one of the menus\n"
        .. "- Right-click on an image's tab to duplicate the image in the editor, or to restore it to its initial state.\n"
        .. "- click and drag an image's tab to the edges of the window to divide the window and display the image separately.\n"
        .. "- click the 'x' on an image's tab to close that copy of the image, the original image on disk will be unaffected") },
    { "About", viz.imageMessage( "Digital Image Processing Project 1", "Authors: Logan Lembke and Benjamin Garcia\nClass: CSC442/542 Digital Image Processing\nDate: Spring 2017" ) }
  }
)

start()
