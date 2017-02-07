require "ip"
require "util"
require "bit32"
local il = require "il"

--pBrighten adds a constant to each channel for each pixel in the image
local function pBrighten(img, amount) 
  return img:mapPixels(
    function(r, g, b) 
      return clip(r + amount), clip(g + amount), clip(b + amount)
    end    
  )
end

--[[
  pGreyscale creates a greyscale image using a
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

--pNegate negates an image
local function pNegate(img)
  return img:mapPixels(
    function(r,g,b)
      return 255 - r, 255- g, 255 - b
    end
  )
end

--pThreshold applies a binary threshold based on Y channel intensities
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
  pContrast takes in an image, a start intensity, and an end intensity.
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
  pGammaTransform takes in an image and a gamma value. This is used to 
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
  pLogTransform uses the lua math library log function to perform a 
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
  pBitPlaneSlice takes in an image and a bit to slice on. The image is
  converted to HSI to get an unweighted average of the channels for the
  intensity. If the intensity bitwise-anded with the bit shifted left
  by the specified amount minus 1 returns a number greater than 0
  then the pixel is set to 255, 255, 255 (pure-white), otherwise the 
  pixel is set to 0, 0, 0.
--]]
local function pBitPlaneSlice (img, bit)
  il.RGB2IHS(img)
  return img:mapPixels(
    function(i, h, s)
      if bit32.band(bit32.lshift(1, bit - 1), i) > 0 then
        return 255, 255, 255
      end
      return 0, 0, 0
    end
  )
end


--[[
  pPosterize reduces the number of distinct intensities that appear
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

--[[
  p8PsuedoColor uses an if statement in order to group intensities
  into 8 bins and assigns colors to those bins
--]]
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

--[[
  pPsuedoColor converts an image to IHS then maps the intensity
  field into the hue field. Then it returns the image converted
  back into RGB.
--]]
local function pPseudoColor(img)
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
  gamma=pGammaTransform,
  log=pLogTransform,
  bitPlaneSlice=pBitPlaneSlice,
  posterize=pPosterize,
  pseudo8=p8PseudoColor,
  pseudo=pPseudoColor
}