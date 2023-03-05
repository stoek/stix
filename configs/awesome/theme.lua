--[[
    Theme by stan
--]]

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local markup = require("markup")
local beautiful= require("beautiful")
local os    = { getenv = os.getenv }
local watch = require("awful.widget.watch")
local naughty = require("naughty")


local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/ergo"
theme.accent                					= "#665c54"
theme.font                                      = "Inconsolata bold 16"
theme.fg_normal                                 = "#ebdbb2"
theme.fg_focus                                  = theme.accent
theme.fg_urgent                                 = "#DDDDFF"
theme.bg_normal                                 = "#101010"
theme.bg_focus                                  = "#101010"
theme.bg_urgent                                 = "#20202000"
theme.border_width                              = 6
theme.border_normal                             = "#202020"
theme.border_focus                              = "#303030"
theme.border_marked                             = "#3F3F3F"
theme.taglist_fg_focus                          = "#ebdbb2"
theme.taglist_fg_empty                          =  "#3c3836"
theme.taglist_fg_occupied                       = "#7c6f64"
theme.taglist_fg_urgent                         = "#cc241d"
theme.taglist_bg_focus                          = "#10101000"
theme.tasklist_fg_focus                         = "#ebdbb2"
theme.tasklist_bg_focus                         = "#101010"
theme.tasklist_bg_urgent                         = "#101010"
theme.red                                       = "#D6504B"
beautiful.menu_bg_normal                            = "#101010"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.menu_height                               = 20
theme.menu_width                                = 140
theme.useless_gap                               = 5
theme.layout_txt_tile                           = "grid"
theme.layout_txt_tileleft                       = "[l]"
theme.layout_txt_tilebottom                     = "[b]"
theme.layout_txt_tiletop                        = "[tt]"
theme.layout_txt_fairv                          = "master"
theme.layout_txt_fairh                          = "[fh]"
theme.layout_txt_spiral                         = "[s]"
theme.layout_txt_dwindle                        = "[d]"
theme.layout_txt_max                            = "max"
theme.layout_txt_fullscreen                     = "[F]"
theme.layout_txt_magnifier                      = "[M]"
theme.layout_txt_floating                       = "[f]"



awful.util.tagnames   = { "vbox", "home", "term", "code", "file", "surf", "docs", "chat", "temp", "musc" }

local white  = theme.fg_normal
local gray   = theme.taglist_fg_focus

-- Textclock
local mytextclock = wibox.widget.textclock(" %H:%M ")
mytextclock.font = theme.font

-- Separators
local spr       = wibox.widget.textbox(' ')
local small_spr = wibox.widget.textbox(markup.font("Inconsolata bold 16", " "))
local bar_spr   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg(theme.font, "#333333", " ") .. markup.font("Inconsolata bold 16", " "))
-- local clock_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", ""))
-- local music_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", ""))
local ram_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", ""))
local wifi_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local ip_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local mode_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local vpn_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local sync_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))



local clock_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg(" Font Awesome 5 Free bold", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local wifi_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg(" Font Awesome 5 Free bold", theme.accent, " ") .. markup.font("Inconsolata bold 16", ""))
local ip_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg(" Font Awesome 5 Free bold", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local mode_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg(" Font Awesome 5 Free bold", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local vpn_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local sync_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("siji", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))
local vol_icon   = wibox.widget.textbox(markup.font("Inconsolata bold 16", " ") .. markup.fontfg("Font Awesome 5 Free bold", theme.accent, "") .. markup.font("Inconsolata bold 16", " "))

vpn_widget = wibox.widget.textbox()
watch(
    "checkvpn", 60,
    function(widget, stdout, stderr, exitreason, exitcode)
    if string.find(stdout, "turned on") then
        widget.markup= "<span color='#b8bb26'>vpn_on</span>"
    else
        widget.markup= "<span color='#D6504B'>vpn_off</span>"
    end
end,
vpn_widget
)
vpn_widget.font ="Inconsolata bold 16"

vol_widget = wibox.widget.textbox()
watch(
    "checkvol", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
    if string.find(stdout, "muted") then
        widget.markup= "<span color='#E3B763'>muted</span>"
    else
        widget.markup= "<span>".. stdout:match'^(.*%S)%s*$' .."</span>"
    end
end,
vol_widget
)

vol_widget.font ="Inconsolata bold 16"

bat1_widget = wibox.widget.textbox()
watch(
    "bat1", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
    widget.markup= "<span>".. stdout:match'^(.*%S)%s*$' .."</span>"
end,
bat1_widget
)

bat1_widget.font ="Inconsolata bold 16"

bat0_widget = wibox.widget.textbox()
watch(
    "bat0", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
    widget.markup= "<span>".. stdout:match'^(.*%S)%s*$' .."</span>"
end,
bat0_widget
)

bat0_widget.font ="Inconsolata bold 16"

ac_icon = wibox.widget.textbox()
watch(
    "ac", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
    if (tonumber(stdout) == 1) then
      widget.markup = markup.font("Inconsolata bold 16", " ") .. markup.fontfg("Font Awesome 5 Free bold", theme.accent, "") .. markup.font("Inconsolata bold 16", " ")
       --widget.text= "<span size=100 color='#E3B763'></span>"
    else
       widget.markup = markup.font("Inconsolata bold 16", " ") .. markup.fontfg("Font Awesome 5 Free bold", theme.accent, "") .. markup.font("Inconsolata bold 16", " ")

        --widget.markup="<span size=100 color='#E3B763'></span>"
       -- widget.markup="<span size=100 color='#E3B763'>test</span>"
    end
end,
ac_icon
)



wifi_widget = wibox.widget.textbox()
watch(
    "iwgetid -r", 10,
    function(widget, stdout, stderr, exitreason, exitcode)
    if (stdout == nil or stdout == "") then
        widget.markup= "<span color='#D6504B'>disconnected</span>"
    else
        widget.markup= "<span color='#ebdbb2'> ".. stdout:match'^(.*%S)%s*$' .."	 </span>"
    end
end,
wifi_widget
)


wifi_widget.font ="Inconsolata bold 16"

local wifi = awful.widget.watch('wifiname', 10, function(widget, sdout)
    if(sdout == nil or sdout == '')		then 
        --widget:set_text("disconnected")
           widget:set_markup("<span foreground='#D6504B'>disconnected</span>")
        else widget:set_text(" " + sdout)
        end
        return
    end)
wifi.font ="Inconsolata bold 16"

local ip = awful.widget.watch('getip', 10, function(widget, sdout)
    if(sdout == nil or sdout == '')		then 
        widget:set_markup("<span foreground='#D6504B'>no ip</span>")
        else widget:set_text(sdout:match'^(.*%S)%s*$')
        end
        return
    end)
ip.font ="Inconsolata bold 16"

local function update_txt_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l = theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.mytxtlayoutbox:set_text(txt_l)
end

function theme.at_screen_connect(s)
    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Textual layoutbox
    s.mytxtlayoutbox = wibox.widget.textbox(theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
    awful.tag.attached_connect_signal(s, "property::layout", function () update_txt_layoutbox(s) end)
    s.mytxtlayoutbox:buttons(awful.util.table.join(
                           awful.button({}, 1, function() awful.layout.inc(1) end),
                           awful.button({}, 3, function() awful.layout.inc(-1) end),
                           awful.button({}, 4, function() awful.layout.inc(1) end),
                           awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 45, bg = "#10101000", fg = theme.fg_normal })

        local  mylayout1 = wibox.layout.align.horizontal()
     mylayout1:set_expand("outside")
    local  mylayout2 = wibox.layout.align.horizontal()
     mylayout2:set_expand("outside")
    local  mylayout3 = wibox.layout.align.horizontal()
     mylayout3:set_expand("outside")
    local  mylayout4 = wibox.layout.align.horizontal()
     mylayout4:set_expand("none")
    -- Add widgets to the wibox
    s.mywibox:setup {
            layout = wibox.layout.fixed.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            small_spr,
            small_spr,
            small_spr,
            vpn_icon,
            vpn_widget,
            ip_icon, 
            ip, 
            wifi_icon, 
            wifi_widget, 
              },
            layout = mylayout4,
        { -- middle widgets
            layout = wibox.layout.fixed.horizontal,
            small_spr,
            s.mytaglist,
            small_spr,
               },

        { -- Right widgets
       layout = wibox.layout.fixed.horizontal,
            small_spr,
            ac_icon,
            bat0_widget,
            small_spr,
            ac_icon,
            bat1_widget,
            small_spr,
            vol_icon,
            vol_widget,
            small_spr,
            clock_icon,
            mytextclock,
            small_spr,
            small_spr,
            small_spr,
            small_spr,
                    },
    }

end

return theme
