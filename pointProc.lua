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


return { brighten=pBrighten }
  
      