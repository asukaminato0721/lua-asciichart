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

local s2 = generateSeries(120)
local s3 = generateSeries(120)

-- Plot the series using the asciichart library
print(asciichart.plot({ s2, s3 }))
