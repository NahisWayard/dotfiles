local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local LIST_ALL = "aerospace list-workspaces --all"
local LIST_CURRENT = "aerospace list-workspaces --focused"
local LIST_MONITORS = "aerospace list-monitors | awk '{print $1}'"
local LIST_WORKSPACES = "aerospace list-workspaces --monitor all"
local LIST_APPS = "aerospace list-windows --workspace %s | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'"

local spaces = {}

local function getIconForApp(appName)
    return app_icons[appName] or "?"
end

local function updateSpaceIcons(spaceId, workspaceName)
    local icon_strip = ""
    local shouldDraw = false

    sbar.exec(LIST_APPS:format(workspaceName), function(appsOutput)
        local appFound = false

        for app in appsOutput:gmatch("[^\r\n]+") do
            local appName = app:match("^%s*(.-)%s*$")  -- Trim whitespace
            if appName and appName ~= "" then
                icon_strip = icon_strip .. " " .. getIconForApp(appName)
                appFound = true
                shouldDraw = true
            end
        end

        if not appFound then
            shouldDraw = false
        end

        if spaces[spaceId] then
            if icon_strip == "" then
                spaces[spaceId].item:set({
                    drawing = false or spaces[spaceId].item:query().label.highlight,
                })
            else
                spaces[spaceId].item:set({
                    label = { string = icon_strip, drawing = shouldDraw, padding_right = 15},
                    drawing = true
                })
            end
        else
            print("Warning: Space ID '" .. spaceId .. "' not found when updating icons.")
        end
    end)
end


local function addWorkspaceItem(workspaceName, monitorId, isSelected)
    local spaceId = "workspace_" .. workspaceName

    if not spaces[spaceId] then
        local space_item = sbar.add("item", spaceId, {
            icon = {
                string = workspaceName,
                padding_left = 5,
                padding_right = 0,
                color = colors.grey,
                highlight_color = colors.yellow,
            },
            label = {
                padding_right = 5,
                padding_left = 0,
                color = colors.grey,
                highlight_color = colors.yellow,
                y_offset = -1,
            },
            padding_left = 1,
            padding_right = 1,
            background = {
                color = colors.bg2,
                border_width = 1,
                height = 24,
                border_color = colors.bg1,
                corner_radius = 9,
            },
            click_script = "aerospace workspace " .. workspaceName,
            display = all --monitorId,
        })

        -- Create bracket for double border effect
        local space_bracket = sbar.add("bracket", { spaceId }, {
            background = {
                color = colors.transparent,
                border_color = colors.transparent,
                height = 26,
                border_width = 1,
                corner_radius = 9,
            }
        })

        -- Subscribe to mouse events for changing workspace
        space_item:subscribe("mouse.clicked", function()
            sbar.exec("aerospace workspace " .. workspaceName)
        end)

        -- Store both the item and its bracket in the spaces table
        spaces[spaceId] = { item = space_item, bracket = space_bracket }
    end

    spaces[spaceId].item:set({
        icon = { highlight = isSelected },
        label = { highlight = isSelected },
    })

    spaces[spaceId].bracket:set({
        background = { border_color = isSelected and colors.dirty_white or colors.transparent }
    })

    updateSpaceIcons(spaceId, workspaceName)
end

local function drawSpaces()
    sbar.exec(LIST_MONITORS, function(monitorsOutput)
        -- Cache the focused workspace to avoid multiple `LIST_CURRENT` queries
        sbar.exec(LIST_CURRENT, function(focusedWorkspaceOutput)
            local focusedWorkspace = focusedWorkspaceOutput:match("[^\r\n]+")
            local workspaces = 

            -- Iterate through monitors and workspaces
--            for monitorId in monitorsOutput:gmatch("[^\r\n]+") do
                sbar.exec(LIST_WORKSPACES:format(monitorId), function(workspacesOutput)
                    for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
                        local isSelected = workspaceName == focusedWorkspace
                        addWorkspaceItem(workspaceName, monitorId, isSelected)
                    end

                    for k, v in pairs(spaces) do
                        local workspace = k:match("workspace_([^\r\n]+)")
                        local b = workspacesOutput:match(workspace)
            
                        if b == nil then
                            sbar.remove(k)
                        end
                    end
                end)
--            end
        end)
    end)
end

drawSpaces()

local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true,
})

space_window_observer:subscribe("aerospace_workspace_change", function(env)
    drawSpaces()
end)

space_window_observer:subscribe("front_app_switched", function()
    -- drawSpaces()
end)

space_window_observer:subscribe("space_windows_change", function()
    -- drawSpaces()
end)
