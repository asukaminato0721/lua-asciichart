-- control sequences for coloring
local asciichart = {}

asciichart.black = "\27[30m"
asciichart.red = "\27[31m"
asciichart.green = "\27[32m"
asciichart.yellow = "\27[33m"
asciichart.blue = "\27[34m"
asciichart.magenta = "\27[35m"
asciichart.cyan = "\27[36m"
asciichart.lightgray = "\27[37m"
asciichart.default = "\27[39m"
asciichart.darkgray = "\27[90m"
asciichart.lightred = "\27[91m"
asciichart.lightgreen = "\27[92m"
asciichart.lightyellow = "\27[93m"
asciichart.lightblue = "\27[94m"
asciichart.lightmagenta = "\27[95m"
asciichart.lightcyan = "\27[96m"
asciichart.white = "\27[97m"
asciichart.reset = "\27[0m"

-- https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
local function round(x)
    return math.floor(x + 0.5)
end
math.round = round
local function colored(char, color)
    -- do not color it if color is not specified
    return color and color .. char .. asciichart.reset or char
end

asciichart.colored = colored

asciichart.plot = function(series, cfg)
    -- this function takes both one array and array of arrays
    -- if an array of numbers is passed, it is transformed to
    -- an array of exactly one array with numbers
    if type(series[1]) == "number" then
        series = { series }
    end

    cfg = cfg or {}

    local min = cfg.min or series[1][1]
    local max = cfg.max or series[1][1]

    for j = 1, #series do
        for i = 1, #series[j] do
            min = math.min(min, series[j][i])
            max = math.max(max, series[j][i])
        end
    end

    local defaultSymbols = { '┼', '┤', '╶', '╴', '─', '╰', '╭', '╮', '╯', '│' }
    local range = math.abs(max - min)
    local offset = cfg.offset or 3
    local padding = cfg.padding or '           '
    local height = cfg.height or range
    local colors = cfg.colors or { nil }
    local ratio = range ~= 0 and height / range or 1
    local min2 = math.round(min * ratio)
    local max2 = math.round(max * ratio)
    local rows = math.abs(max2 - min2)
    local width = 0
    for i = 1, #series do
        width = math.max(width, #series[i])
    end
    width = width + offset
    local symbols = cfg.symbols or defaultSymbols
    local format = cfg.format or function(x)
        return (padding .. string.format("%.2f", x)):sub(- #padding)
    end

    local result = {}
    for i = 1, rows + 1 do -- empty space
        result[i] = {}
        for j = 1, width do
            result[i][j] = ' '
        end
    end

    for y = min2, max2 do -- axis + labels
        local label = format(rows > 0 and max - (y - min2) * range / rows or y, y - min2)
        result[y - min2 + 1][math.max(offset - #label, 0) + 1] = label
        result[y - min2 + 1][offset] = (y == 0) and symbols[1] or symbols[2]
    end

    for j = 1, #series do
        -- {nil} size is 0 https://stackoverflow.com/questions/23590885/why-does-luas-length-operator-return-unexpected-values
        local currentColor = colors[(j - 1) % math.max(1, #colors) + 1]
        local y0 = math.round(series[j][1] * ratio) - min2
        result[rows - y0 + 1][offset] = colored(symbols[1], currentColor) -- first value

        for x = 1, #series[j] - 1 do                                      -- plot the line
            local y0 = math.round(series[j][x + 0] * ratio) - min2
            local y1 = math.round(series[j][x + 1] * ratio) - min2
            if y0 == y1 then
                result[rows - y0 + 1][x + offset + 1] = colored(symbols[5], currentColor)
            else
                result[rows - y1 + 1][x + offset + 1] = colored((y0 > y1) and symbols[6] or symbols[7], currentColor)
                result[rows - y0 + 1][x + offset + 1] = colored((y0 > y1) and symbols[8] or symbols[9], currentColor)
                local from = math.min(y0, y1)
                local to = math.max(y0, y1)
                for y = from + 1, to - 1 do
                    result[rows - y + 1][x + offset + 1] = colored(symbols[10], currentColor)
                end
            end
        end
    end

    local output = {}
    for i = 1, #result do
        output[i] = table.concat(result[i])
    end
    return table.concat(output, '\n')
end

-- return asciichart

return asciichart
