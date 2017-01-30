require "ip"
require "util"
local il = require "il"

--Adds a constant to each channel for each pixel in the image
local function pBrighten(img, amount) 
  return img:mapPixels(
    function(r, g, b) 
      return clip(r + amount), clip(g + amount), clip(b + amount)
    end    
  )
end

--[[
Creates a greyscale image using a
formula similar to the Y value in the 
YIQ color model
--]]
local function pGreyscale(img)
  return img:mapPixels(
    function(r,g,b)
      local value = round(r * .30 + g *.59 + b * .11)
      return value, value, value
    end
  )
end

--Negates an image
local function pNegate(img)
  return img:mapPixels(
    function(r,g,b)
      return 255 - r, 255- g, 255 - b
    end
  )
end

--Apply a binary threshold based on Y channel intensities
local function pThreshold(img, threshold)
  --find greyscale intensities via YIQ
  il.RGB2YIQ(img)
  --write rgb values based on y channel
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
  Takes in an image, a start intensity, and an end intensity.
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
      return clip(slope * (y - rangeStart), 0, 255), i, q
    end
  )
  il.YIQ2RGB(img)
  return img
end

--[[
  Takes in an image and determines the darkest and lightest intensities
  present in the image. A contrast stretch is then performed with these as the
  rangeStart and rangeEnd values.
--]]
local function pContrastAuto (img)
  il.RGB2YIQ(img)
  local histogram, min, max = createHistogram(img), 0, 0
  il.YIQ2RGB(img)
  local i, count = 1000, 0
  while true do
    i = i - histogram[count]
    if i < 0 then
      min = count
      break
    end
    count = count + 1
  end
  i, count = 1000, 255
  while true do
    i = i - histogram[count]
    if i < 0 then
      max = count
      break
    end
    count = count - 1
  end
  --call pContrast directly with min and max
  return pContrast(img, min, max)
end

--[[
  This function takes in the percentage of low and high intensity pixels
  to ignore. Once the resulting range is computed, a contrast stretch is
  performed.
--]]
local function pContrastPercentage (img, lowPercent, highPercent)
  local pixels = img.width * img.height
  local pixL, pixH = pixels * (0.01 * lowPercent), pixels * (1- (0.01 * highPercent))
  il.RGB2YIQ(img)
  local histogram = createHistogram(img)
  il.YIQ2RGB(img)
  local sum, min, max = 0, 0, 255
  while sum < pixL do
    sum = sum + histogram[min]
    min = min + 1
  end
  sum = 0
  while sum < pixH do
    sum = sum + histogram[max]
    max = max - 1
  end
  return pContrast(img, min, max)
end

--[[
  This function takes in an image and a gamma value. This is used to 
  increase contrast between low intensities and decrease it between
  high intensities, or vice-versa. The tranform is being performed on
  the intensity values of the pixels.
--]]
local function pGammaTransform (img, gamma)
  il.RGB2YIQ(img)
  img:mapPixels(
    function (y, i, q)
      return clip(255*(y/255)^gamma, 0, 255), i, q
    end
  )
  il.YIQ2RGB(img)
  return img
end

--[[
  This function uses the lua math library log function to perform a 
  log transformation on a provided image. The transform is being
  performed on the intensity values of the pixels.
--]]
local function pLogTransform (img)
  il.RGB2YIQ(img)
  img:mapPixels(
    function (y, i, q)
      --log base 256 normalizes an input of 255 to 1, which is then
      --mapped back into the usable range of 0-255
      return clip(math.log(1 + y, 256)*255, 0, 255), i, q
    end
  )
  il.YIQ2RGB(img)
  return img
end

--[[
  This function reduces the number of distinct intensities that appear
  in the image. The image is converted to YIQ and posterized on the 'y'
  component of each pixel.
  NOTE: Last modified by Ben, needs review by Logan.
--]]
local function pPosterize(img, levels)
  -- create a posterize function for levels
  local posterize = function(input) 
    --using the theory of function transforms
    -- 255 / (levels - 1) controls the jump in height for each level
    -- input / 256 * levels controls the width of each interval
    return 255 / (levels - 1) * math.floor(input * levels / 256)
  end

--convert to YIQ, posterize intensity, and return an RGB image
  il.RGB2YIQ(img)
  img:mapPixels(
    function(y, i, q)
      return posterize(y), i, q
    end
  )
  return il.YIQ2RGB(img)
end

local function p8PseudoColor(img) 
  return img:mapPixels(
    function(r, g, b)
      --assume the image is rgb greyscale
      --use r as the channel
      if r < 256 / 8 then
        return 0, 0, 0 --black
      elseif r < 256 / 8 * 2 then
        return 255, 0, 0 --red 
      elseif r < 256 / 8 * 3 then
        return 0, 255, 0 --green
      elseif r < 256 / 8 * 4 then
        return 0, 0, 255 --blue
      elseif r < 256 / 8 * 5 then
        return 255, 255, 0 --yellow
      elseif r < 256/ 8 * 6 then
        return 0, 255, 255 --cyan
      elseif r < 256 / 8 * 7 then
        return 255, 0, 255 --magenta
      end
      return 255, 255, 255 --white
    end
  )
end

local function pseudoColor(img)
  il.RGB2IHS(img)
  img:mapPixels(
    function(i)
      --assume the image is rgb greyscale
      return 200, i, 200
    end
  )
  return il.IHS2RGB(img)
end

return { 
  brighten=pBrighten,
  greyscale=pGreyscale,
  negate=pNegate,
  threshold=pThreshold,
  contrastStretch=pContrast,
  autoContrastStretch=pContrastAuto,
  percentageContrastStretch=pContrastPercentage,
  gamma=pGammaTransform,
  log=pLogTransform,
  posterize=pPosterize,
  pseudo8=p8PseudoColor,
  pseudo=pseudoColor
}