require "util"
require "ip"
local pProc = require "pointProc"
local il = require "il"

--[[
  hContrastAuto takes in an image and determines the darkest and lightest intensities
  present in the image. A contrast stretch is then performed with these as the
  rangeStart and rangeEnd values.
--]]
local function hContrastAuto (img)
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
  return pProc.contrastStretch(img, min, max)
end

--[[
  hContrastPercentage takes in the percentage of low and high intensity pixels
  to ignore. Once the resulting range is computed, a contrast stretch is
  performed.
--]]
local function hContrastPercentage (img, lowPercent, highPercent)
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
  return pProc.contrastStretch(img, min, max)
end

--[[
  hHistogramEqualization attempts to flatten an images histogram by
  applying a transformation based on the CDF of pixel intensities.
--]]
local function hHistogramEqualization (img)
  il.RGB2YIQ(img)
  local histogram = createHistogram(img)
  --cdf the cumulative distribution function
  local cdf = {}
  --pixels is the normalization factor for the histogram
  local pixels = img.width * img.height

  --start the summing process of the frequency histogram
  cdf[0] = histogram[0] / pixels
  for i = 1,255 do
    cdf[i] = cdf[i-1] + (histogram[i] / pixels)
  end

  img:mapPixels(
    function(y, i, q)
      return 255 * cdf[y], i, q
    end
  )

  il.YIQ2RGB(img)
  return img
end    

--[[
  hClippedHistogramEqualization attempts to flatten an images histogram by
  applying a transformation based on the CDF of pixel intensities.
  Each intensity is clipped down to hold (100 - percentage) / 100 pixels
  so as not to over-represent certain intensities.
--]]
local function hClippedHistogramEqualization (img, percentage)
  --Normalize and invert the percentage
  percentage = clip(percentage / 100, 0, 1)

  il.RGB2YIQ(img)
  local histogram = createHistogram(img)
  local cdf = {}
  local threshold = img.width * img.height * percentage

  --start the summing process
  cdf[0] = clip(histogram[0], 0, threshold)
  for i = 1,255 do
    cdf[i] = cdf[i-1] + clip(histogram[i], 0, threshold)
  end

  --convert to a frequency histogram
  local normalization = cdf[255]
  for i = 1, 255 do
    cdf[i] = cdf[i] / normalization
  end

  img:mapPixels(
    function(y, i, q)
      return 255 * cdf[y], i, q
    end
  )

  il.YIQ2RGB(img)
  return img
end

return {
  histogramEqualization=hHistogramEqualization,
  clippedHistogramEqualization=hClippedHistogramEqualization,
  autoContrastStretch=hContrastAuto,
  percentageContrastStretch=hContrastPercentage,
}