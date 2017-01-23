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

    