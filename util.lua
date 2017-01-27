--print and io:write do not seem to work... so this is used
function print(msg) 
  io.output(io.stdout):write(msg)
end

--only works when penlight is installed
function dumpTable(table)
  debug(require 'pl.pretty'.write(table))
end

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

  if input < low then
    input = low
  elseif input > high then
    input = high
  end
  return input
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