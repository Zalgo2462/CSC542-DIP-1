require "ip"
require "util"

-- applies a point process function to an image
local function pProcess(process, img)
  for row = 0, img.height - 1, 1 do
    for column = 0, img.width - 1, 1 do
      process(img:at(row,column).rgb)
    end
  end
  return img
end

local function pBrighten(img) 
  amnt = 10
  return pProcess( 
    function(rgb) 
      for channel = 0, 2 do
        rgb[channel] = clip(rgb[channel] + amnt, 0, 255)
      end
    end,
  img)
end

return { brighten=pBrighten }
  
      