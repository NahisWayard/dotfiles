local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

createWidget = function (label, icon)
    return {
        position = "right",
        graph = { color = colors.blue },
        background = {
            height = 22,
            color = { alpha = 0 },
            border_color = { alpha = 0 },
            drawing = true,
        },
        icon = {
            string = icon,
            font = {
                size = 17.0,
            },
        },
        label = {
            string = label,
            font = {
                size = 9.0,
            },
            align = "right",
            padding_right = 0,
            width = 0,
            y_offset = 4
        },
        padding_right = settings.paddings + 6,
    }
end

return createWidget