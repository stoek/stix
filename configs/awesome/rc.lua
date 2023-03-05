--[[
     gitlab.com/stugg/dotfiles
                                       
--]] -- {{{ Required libraries
local awesome, client, screen, tag = awesome, client, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os,
                                                            table, tostring,
                                                            tonumber, type
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget
naughty.config.defaults['icon_size'] = 100

-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then findme = cmd:sub(0, firstspace - 1) end
        awful.spawn.with_shell(string.format(
                                   "pgrep -u $USER -x %s > /dev/null || (%s)",
                                   findme, cmd))
    end
end

run_once({"urxvtd", "unclutter -root"})
awful.util.spawn("autostart")



-- }}}

-- {{{ Variable definitions
local modkey = "Mod4"
local altkey = "Mod1"
local terminal = "urxvt"
local editor = os.getenv("EDITOR") or "nano" or "vi"
local gui_editor = "code"
local browser = "firefox"
local filemanager = "thunar"

beautiful.useless_gap = 8

awful.util.terminal = terminal
awful.util.tagnames = {
    "home", "term", "code", "file", "surf", "docs", "chat", "musc", "xtra"
}
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.append_default_layouts({
    awful.layout.suit.tile,
    awful.layout.suit.max,
})


awful.util.taglist_buttons = awful.util.table.join(
                                 awful.button({}, 1,
                                              function(t) t:view_only() end),
                                 awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end), awful.button({}, 3, awful.tag.viewtoggle),
                                 awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
                                 awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end))

awful.util.tasklist_buttons = awful.util.table.join(
                                  awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end), awful.button({}, 3, function()
        local instance = nil

        return function()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                                  awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))


    -- This is the correct way
awful.spawn.easy_async_with_shell("checkmon", function(out)
    if out == "DisplayPort-0" then
        local theme_path = string.format("%s/.config/awesome/thememonitor.lua",
        os.getenv("HOME"))
        beautiful.init(theme_path)
        beautiful.menu_bg_normal = "#151515"

-- Create a wibox for each screen and add it
        awful.screen.connect_for_each_screen(
            function(s) beautiful.at_screen_connect(s) end)
-- }}}
    else
        local theme_path = string.format("%s/.config/awesome/theme.lua",
        os.getenv("HOME"))
        beautiful.init(theme_path)
        beautiful.menu_bg_normal = "#151515"

        awful.screen.connect_for_each_screen(
            function(s) beautiful.at_screen_connect(s) end)

        awful.screen.connect_for_each_screen(function(s)  -- that way the wallpaper is applied to every screen 
            tw("*", s, {        -- call the actual function ("x" is the string that will be tiled)
                fg = "#ff0000",  -- define the foreground color
                bg = "#151515",  -- define the background color
                offset_y = 25,   -- set a y offset
                offset_x = 25,   -- set a x offset
                font = "Consolas Bold",   -- set the font (without the size)
                font_size = 14,  -- set the font size
                padding = 100,   -- set padding (default is 100)
                zickzack = true  -- rectangular pattern or criss cross
            })
        end)
    end
end)

print("It really works this time!")



-- }}}

-- {{{ Menu
local myawesomemenu = {
    {"hotkeys", function() return false, hotkeys_popup.show_help end},
    {"manual", terminal .. " -e man awesome"}, {
        "edit config",
        string.format("%s -e %s %s", terminal, editor, awesome.conffile)
    }, {"restart", awesome.restart}, {"quit", function() awesome.quit() end}
}

awful.util.mymainmenu = awful.menu({
    items = {
        {"awesome", myawesomemenu}, {"file manager", filemanager},
        {"user terminal", terminal}, {"lock", "lock2.sh"}
    }
})



-- {{{ Mouse bindings
root.buttons(awful.util.table.join(awful.button({}, 3, function()
    awful.util.mymainmenu:toggle()
end), awful.button({}, 4, awful.tag.viewnext),
                                   awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join( -- Take a screenshot/sh
-- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
awful.key({altkey}, "p", function() os.execute("screenshot") end),
awful.key({altkey}, "space", function() awful.spawn("betterlock") end),

awful.key({modkey}, "Escape", awful.tag.history.restore,
          {description = "go back", group = "tag"}),

awful.key({modkey}, "j", function() awful.client.focus.byidx(1) end,
          {description = "focus next by index", group = "client"}),
awful.key({modkey}, "k", function() awful.client.focus.byidx(-1) end,
          {description = "focus previous by index", group = "client"}),

awful.key({modkey}, "l", function() awful.tag.incmwfact(0.05) end),
awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end),

awful.key({modkey}, "w", function() awful.util.mymainmenu:show() end,
          {description = "show main menu", group = "awesome"}),

-- Layout manipulation
awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end,
          {description = "swap with next client by index", group = "client"}),
awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end, {
    description = "swap with previous client by index",
    group = "client"
}), awful.key({modkey, "Control"}, "j",
              function() awful.screen.focus_relative(1) end,
              {description = "focus the next screen", group = "screen"}),
awful.key({modkey, "Control"}, "k",
          function() awful.screen.focus_relative(-1) end,
          {description = "focus the previous screen", group = "screen"}),
awful.key({modkey}, "u", awful.client.urgent.jumpto,
          {description = "jump to urgent client", group = "client"}),
awful.key({modkey}, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then client.focus:raise() end
end, {description = "go back", group = "client"}), -- Show/Hide Wibox
awful.key({modkey}, "b", function()
    for s in screen do
        s.mywibox.visible = not s.mywibox.visible
        if s.mybottomwibox then
            s.mybottomwibox.visible = not s.mybottomwibox.visible
        end
    end
end), -- Launcher
awful.key({modkey}, "d", function() awful.spawn("launch") end),

-- Standard program
awful.key({modkey}, "Return", function() awful.spawn(terminal) end,
          {description = "open a terminal", group = "launcher"}),

awful.key({modkey, "Shift"}, "h",
          function() awful.tag.incnmaster(1, nil, true) end, {
    description = "increase the number of master clients",
    group = "layout"
}), awful.key({modkey, "Shift"}, "l",
              function() awful.tag.incnmaster(-1, nil, true) end, {
    description = "decrease the number of master clients",
    group = "layout"
}), awful.key({modkey}, "'", function() awful.tag.incncol(1, nil, true) end, {
    description = "increase the number of columns",
    group = "layout"
}), awful.key({modkey}, ";", function() awful.tag.incncol(-1, nil, true) end, {
    description = "decrease the number of columns",
    group = "layout"
}), awful.key({modkey}, "space", function() awful.layout.inc(1) end,
              {description = "select next", group = "layout"}),
awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(-1) end,
          {description = "select previous", group = "layout"}),

-- Dropdown application
awful.key({modkey}, "z", function() awful.screen.focused().quake:toggle() end),
awful.key({modkey, "Shift"}, "x", function() awesome.quit() end),


-- ALSA volume control
awful.key({}, "XF86AudioRaiseVolume", function()
    os.execute("volup")
end), awful.key({}, "XF86AudioLowerVolume", function()
    os.execute("voldown")
end), awful.key({}, "XF86AudioMute", function()
    os.execute("volmute")
end)
)

clientkeys = awful.util.table.join(awful.key({modkey}, "m",
                                             awful.client.movetoscreen),
                                   awful.key({modkey}, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
end, {description = "toggle fullscreen", group = "client"}),
                                   awful.key({modkey}, "q",
                                             function(c) c:kill() end, {
    description = "close",
    group = "client"
}), awful.key({modkey}, "o", awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
                                   awful.key({modkey, "Shift"}, "Return",
                                             function(c)
    c:swap(awful.client.getmaster())
end, {description = "move to master", group = "client"}),
                                   awful.key({modkey}, "t", function(c)
    c.ontop = not c.ontop
end, {description = "toggle keep on top", group = "client"}),
                                   awful.key({modkey}, "`", function(c)
    c.maximized = not c.maximized
    c:raise()
end, {description = "maximize", group = "client"}))

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 0, 10 do
    globalkeys = awful.util.table.join(globalkeys, -- View tag only.
    awful.key({modkey}, "#" .. i + 8, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then tag:view_only() end
    end, {description = "view tag #" .. i, group = "tag"}),
    -- Toggle tag display.
                                       awful.key({modkey, "Control"},
                                                 "#" .. i + 8, function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then awful.tag.viewtoggle(tag) end
    end, {description = "toggle tag #" .. i, group = "tag"}),
    -- Move client to tag.
                                       awful.key({modkey, "Shift"},
                                                 "#" .. i + 8, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:move_to_tag(tag) end
        end
    end, {description = "move focused client to tag #" .. i, group = "tag"}),
    -- Toggle tag on focused client.
                                       awful.key({modkey, "Control", "Shift"},
                                                 "#" .. i + 8, function()
        if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then client.focus:toggle_tag(tag) end
        end
    end, {description = "toggle focused client on tag #" .. i, group = "tag"}))
end

globalkeys = awful.util.table.join(globalkeys, -- View tag only.
awful.key({modkey}, "0", function()
    local screen = awful.screen.focused()
    local tag = screen.tags[1]
    if tag then tag:view_only() end
end, {description = "view tag #" .. 0, group = "tag"}), -- Toggle tag display.
awful.key({modkey, "Control"}, "0", function()
    local screen = awful.screen.focused()
    local tag = screen.tags[1]
    if tag then awful.tag.viewtoggle(tag) end
end, {description = "toggle tag #" .. 0, group = "tag"}),
-- Move client to tag.
                                   awful.key({modkey, "Shift"}, "0", function()
    if client.focus then
        local tag = client.focus.screen.tags[1]
        if tag then client.focus:move_to_tag(tag) end
    end
end, {description = "move focused client to tag #" .. 0, group = "tag"}),
-- Toggle tag on focused client.
                                   awful.key({modkey, "Control", "Shift"}, "0",
                                             function()
    if client.focus then
        local tag = client.focus.screen.tags[1]
        if tag then client.focus:toggle_tag(tag) end
    end
end, {description = "toggle focused client on tag #" .. 0, group = "tag"}))

clientbuttons = awful.util.table.join(awful.button({}, 1, function(c)
    client.focus = c;
    c:raise()
end), awful.button({modkey}, 1, awful.mouse.client.move), awful.button({modkey},
                                                                       3,
                                                                       awful.mouse
                                                                           .client
                                                                           .resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap +
                awful.placement.no_offscreen,
            size_hints_honor = false
        }
    }, -- Titlebars
    {
        rule_any = {type = {"dialog", "normal"}},
        properties = {titlebars_enabled = false}
    }, -- Set Firefox to always map on the first tag on screen 1.
    {
        rule = {class = "Chromium"},
        properties = {screen = 1, tag = screen[1].tags[6]}
    },

    {
        rule = {class = "Emacs"},
        properties = {screen = 1, tag = screen[1].tags[4]}
    }, {
        rule = {class = "megasync"},
        properties = {screen = 1, tag = screen[1].tags[8]}
    }, {rule = {class = "megasync"}, properties = {floating = true}},

    {rule = {class = "connman-gtk"}, properties = {floating = true}},

    {
        rule = {class = "google-chrome-unstable"},
        properties = {maximized = false}
    }, {rule = {class = "stalonetray"}, properties = {floating = true}}, {
        rule = {class = "Gimp", role = "gimp-image-window"},
        properties = {maximized = true}
    }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and
        not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
                        awful.button({}, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end), awful.button({}, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end))

    awful.titlebar(c, {size = 16}):setup{
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)


-- awful.screen.connect_for_each_screen(function(s)  -- that way the wallpaper is applied to every screen 
--     tw("*", s, {        -- call the actual function ("x" is the string that will be tiled)
--         fg = "#ff0000",  -- define the foreground color
--         bg = "#151515",  -- define the background color
--         offset_y = 25,   -- set a y offset
--         offset_x = 25,   -- set a x offset
--         font = "Consolas Bold",   -- set the font (without the size)
--         font_size = 14,  -- set the font size
--         padding = 100,   -- set padding (default is 100)
--         zickzack = true  -- rectangular pattern or criss cross
--     })
-- end)




-- still not sure if i like this?
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and
        awful.client.focus.filter(c) then client.focus = c end
end)

-- No border for maximized clients
client.connect_signal("focus", function(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end)
client.connect_signal("unfocus",
                      function(c) c.border_color = beautiful.border_normal end)
-- }}}
--

