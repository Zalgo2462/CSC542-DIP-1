require "ip"
require "util"
local il = require "il"


local function pBrighten(img, amount) 
  return img:mapPixels(
    function(r, g, b) 
      return clip(r + amount), clip(g + amount), clip(b + amount)
    end    
  )
end

local function pGreyscale(img)
  return img:mapPixels(
    function(r,g,b)
      local value = round(r * .30 + g *.59 + b * .11)
      return value, value, value
    end
  )
end

local function pNegate(img)
  return img:mapPixels(
    function(r,g,b)
      return 255 - r, 255- g, 255 - b
    end
  )
end

local function pThreshold(img, threshold)
  il.RGB2YIQ(img)
  return img:mapPixels(
    function(y) 
      if (y > threshold) then
        return 255, 255, 255
      else
        return 0, 0, 0
      end
    end
  )
end
  

return { 
  brighten=pBrighten,
  greyscale=pGreyscale,
  negate=pNegate,
  threshold=pThreshold
}
  
      