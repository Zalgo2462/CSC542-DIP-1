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

--[[
  Description: This function takes in an image, a start intensity, and an end intensity.
  From this the intensity of each pixel is adjusted to improve the detail of
  pixels with intensity values between the start and end, and clips those
  that are lower or higher.
--]]
local function pContrast (img, rangeStart, rangeEnd)
  --ensure that the start value is less than the end value,
  --if it is not, then switch the values
  if rangeStart > rangeEnd then
    rangeStart,rangeEnd = rangeEnd,rangeStart
  end
  il.RGB2YIQ(img)
  img:mapPixels(
    function (y, i, q)
      local slope = 255/(rangeEnd - rangeStart) --slope of the intensity graph
      --TODO: confirm that this works as intended
      if y < rangeStart then
        --clip the pixel that is below the start intensity
        return 0, i, q
      elseif y > rangeEnd then
        --clip the pixel that is above the end intensity
        return 255, i, q
      else
        --perform the contrast adjustment and clip
        return clip(y*slope + rangeStart, 0, 255), i, q
      end
    end
  )
  il.YIQ2RGB(img)
  return img
end

local function pPosterize(img, levels)
  il.RGB2YIQ(img)
  img:mapPixels(
    function(y, i, q)
      local level = math.floor(y / 255 * levels)
      if (level == 0) then
        return 0, i, q
      end      
      return 255 / level, i, q
    end
  )
  return il.YIQ2RGB(img)
end

local function pPosterize2(img, levels)
  -- create a posterize function for levels
  local posterize = function(input) 
    --using the theory of function transforms
    -- 255 / (levels - 1) controls the jump in height for each level
    -- input / 256 * levels controls the width of each interval
    return 255 / (levels - 1) * math.floor(input * levels / 256)
  end
  
  return img:mapPixels(
    function(r, g, b)
      return posterize(r), posterize(g), posterize(b)
    end
  )
end


return { 
  brighten=pBrighten,
  greyscale=pGreyscale,
  negate=pNegate,
  threshold=pThreshold,
  contrastStretch=pContrast,
  posterize=pPosterize2
}
