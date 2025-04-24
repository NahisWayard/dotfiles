local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local widget = require("items.widgets.default_widget")("", icons.ramicons.ram)

widget.update_freq = 180

local ram = sbar.add("graph", "widgets.ram", 42, widget)

-- Background around the ram items
sbar.add("bracket", "widgets.ram.bracket", { ram.name }, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
})

-- Background around the ram item
sbar.add("item", "widgets.ram.padding", {
	position = "right",
	width = settings.group_paddings
})


ram:subscribe({ "routine", "forced" }, function(env)
	sbar.exec("memory_pressure | grep -o 'System-wide memory free percentage: [0-9]*' | awk '{print $5}'",
		function(freeram)
			local usedram = 100 - tonumber(freeram)
			local Color = colors.blue
			local label = "ram " .. tostring(usedram) .. "%"

			if usedram >= 90 then
				Color = colors.red
				label = "KILL ME"
				Padding_left = 0
			elseif usedram >= 80 then
				Color = colors.red
			elseif usedram >= 50 then
				Color = colors.orange
			elseif usedram >= 33 then
				Color = colors.yellow
			end

			ram:set({
				label = {
					string = label,
					padding_left = Padding_left,
				},
				icon = {
				},
			})

			ram:push({ usedram / 100. })

			ram:set({
				graph = { color = Color },
				label = "ram " .. usedram .. "%",
			})
		end)
end)
