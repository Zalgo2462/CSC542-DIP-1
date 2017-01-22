
--print and io:write do not seem to work... so this is used
function print(msg) 
  io.output(io.stdout):write(msg)
end

--only works when penlight is installed
function dumpTable(table)
  debug(require 'pl.pretty'.write(table))
end

function clip (input, low, high) 
  if input < low then
    input = low
  elseif input > high then
    input = high
  end
  return input
end

    