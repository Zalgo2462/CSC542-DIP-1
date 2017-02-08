--[[

  * * * * util.lua * * * *

Util functions which the lua library doesn't have

Authors: Logan Lembke and Benjamin Garcia
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

function round (input) 
  return math.floor(input + .5)
end

function clip (input, low, high) 
  if low == nil then
    low = 0
  end
  if high == nil then
    high = 255
  end
  
  return math.min(high, math.max(low, input))
end

--[[
  this function creates a histogram table from an image.
  The function is assuming a YIQ image.
--]]
function createHistogram (img)
  --create an array of "size" 256, zero-indexed
  local histogram = {}
  for i = 0, 255 do
    histogram[i] = 0
  end
  img:mapPixels(
    function (y, i, q)
      histogram[y] = histogram[y] + 1
      return y, i, q
    end
  )
  return histogram
end