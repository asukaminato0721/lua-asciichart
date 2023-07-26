local asciichart = require("asciichart")

-- Function to generate a random integer within the specified range
local function getRandomInt(min, max)
    return math.random(min, max)
end

-- Function to generate the series
local function generateSeries(length)
    local series = {}
    series[1] = getRandomInt(0, 15)
    
    for i = 2, length do
        local randomNum = getRandomInt(0, 1) > 0.5 and 2 or -2
        series[i] = series[i - 1] + randomNum
    end
    
    return series
end

-- Generate four arrays
local arr1 = generateSeries(120)
local arr2 = generateSeries(120)
local arr3 = generateSeries(120)
local arr4 = generateSeries(120)

-- Create the config table for asciichart
local config = {
    colors = {
        asciichart.blue,
        asciichart.green,
        asciichart.default, -- default color
        nil, -- equivalent to default (nil in Lua)
    }
}

-- Plot the arrays using the asciichart library
print(asciichart.plot({arr1, arr2, arr3, arr4}, config))
