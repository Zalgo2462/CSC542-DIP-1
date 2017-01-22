--[[

  --This file contains in progress point processes for Programming Assignment 1
  
  --Author: Benjamin Garcia
  --Class: CSC-442/542 Digital Image Processing
  --Date: 1/21/2017

--]]

-- task 5: increase/decrease brightness based on user input --
function adjustBrightness (image, value)
  local height, width = image.height, image.width
  for row = height, 1, -1 do
    for column = width, 1, -1 do
      for channel = 0, 2 do        
        image:at(row,column).rgb[channel] = image:at(row,column).rgb[channel] + value
        if image:at(row,column).rgb[channel] > 255 then
          image:at(row,column).rgb[channel] = 255
        elseif image:at(row,column).rgb[channel] < 0 then
          image:at(row,column).rgb[channel] = 0
        end
      end
    end
  end
end