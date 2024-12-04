local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local widget = require("items.widgets.default_widget")("", icons.cpu)
local cpu = sbar.add("graph", "widgets.cpu", 42, widget)

cpu:subscribe("cpu_update", function(env)
	local load = tonumber(env.total_load)
	cpu:push({ load / 100. })

	local color = colors.blue
	if load > 30 then
		if load < 60 then
			color = colors.yellow
		elseif load < 80 then
			color = colors.orange
		else
			color = colors.red
		end
	end

	cpu:set({
		graph = { color = color },
		label = "cpu " .. env.total_load .. "%",
	})
end)

cpu:subscribe("mouse.clicked", function(env)
	sbar.exec("alacritty msg create-window --command /opt/homebrew/bin/btop")
end)

-- Background around the cpu items
sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
	background = {
		color = colors.bg2,
		border_color = colors.bg1,
		border_width = 2,
	},
})

-- Background around the cpu item
sbar.add("item", "widgets.cpu.padding", {
	position = "right",
	width = settings.group_paddings
})
