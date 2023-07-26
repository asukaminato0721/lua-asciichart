local asciichart = require("asciichart")
local s0 = {}

for i = 1, 120 + 1 do
    s0[i] = 15 * math.sin(i * ((math.pi * 4) / 120))
end
print(asciichart.plot(s0))
