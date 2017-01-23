require "ip"
require "util"


local function pBrighten(img) 
  amnt = 10  
  return img:mapPixels(
    function(r, g, b) 
      return clip(r + amnt), clip(g + amnt), clip(b + amnt)
    end    
  )
end

local function pGreyscale(img)
  return img:mapPixels(
    function(r,g,b)
      local value = round((r * .30 + g *.59 + b * .11))
      return value, value, value
    end
  )
end



return { 
  brighten=pBrighten,
  greyscale=pGreyscale
}
  
      