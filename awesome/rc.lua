-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local theme = require("beautiful")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "/themes/default/theme.lua")
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init("~/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("vscode") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"


-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "Hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "Manual", terminal .. " -e man awesome" },
   { "Edit Config", editor_cmd .. " " .. awesome.conffile },
   { "Restart", awesome.restart },
   { "Quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Open Terminal", "kitty" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = kitty -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("  %a %b %d, %Y   %I:%M %p ", 1, "America/Toronto")
-- Create a month calendar popup and attach it to the textclock
--month_calendar = awful.widget.calendar_popup.month({start_sunday = false})  
--month_calendar:attach( mytextclock, "tc" )       

-- Enhance the calendar popup with theme-based colors and center the text
month_calendar = awful.widget.calendar_popup.month({
    start_sunday = false, -- Keep your preference
    bg = theme.bg_normal, -- Use your theme's background color
    style_month = {
        shape = gears.shape.rounded_rect, -- Modern rounded style
        border_width = 2,
        border_color = theme.bg_focus, -- Use your focus color for borders
        align = "center" -- Center the month name
    },
    style_header = {
        shape = gears.shape.rounded_rect, -- Rounded header for month name
        bg_color = theme.bg_focus,       -- Header background to match focus color
        fg_color = theme.fg_focus,       -- Text color for header (month name)
        align = "center"                 -- Center the header text (month)
    },
    style_weekday = {
        shape = gears.shape.rounded_rect, -- Rounded weekdays
        bg_color = theme.bg_minimize,    -- Weekdays background color
        fg_color = theme.fg_normal,      -- Weekdays text color
        align = "center"                 -- Center weekday text
    },
    style_normal = {
        shape = gears.shape.rounded_rect, -- Normal day shape
        bg_color = theme.bg_normal,      -- Day background color
        fg_color = theme.fg_normal,      -- Normal day text color
        align = "center"                 -- Center the date text
    },
    style_focus = {
        shape = gears.shape.rounded_rect, -- Focused day shape
        bg_color = theme.bg_focus,       -- Focused day background
        fg_color = theme.fg_focus,       -- Focused day text color
        align = "center"                 -- Center the focused date text
    },
})
month_calendar:attach(mytextclock, "tc")

-- Create Power Menu Widget
myPowerMenu = wibox.widget {
	text = "",
	widget = wibox.widget.textbox
}
myPowerMenu.font = "FontAwesome 13"

myPowerMenu:connect_signal("button::press",
	function ()
		awful.spawn.with_shell("~/Documents/Scripts/powermenu.sh")
	end
)

-- Create Wifi Menu Widget
myWifiMenu = wibox.widget {
	text = "",
	widget = wibox.widget.textbox
}
myWifiMenu.font = "FontAwesome 14"

local function update_wifi_icon() 
    awful.spawn.easy_async_with_shell("nmcli -fields WIFI g", function(stdout)
        if stdout:match("enabled") then 
            myWifiMenu.text = "" 
        else 
            myWifiMenu.text = "" 
        end 
    end) 
end 

-- Initial check 
update_wifi_icon() 

-- Create a timer to update the icon periodically 
gears.timer { 
    timeout = 5,        -- check every 5 seconds 
    autostart = true, 
    callback = update_wifi_icon 
}

myWifiMenu:connect_signal("button::press",
	function ()
		awful.spawn.with_shell("~/.local/share/rofi-wifi-menu/rofi-wifi-menu.sh")
	end
)

-- Create Bluetooth Menu Widget
myBluetoothMenu = wibox.widget {
	text = "",
	widget = wibox.widget.textbox
}
myBluetoothMenu.font = "FontAwesome 13"


-- Volume Widget
myVolume = wibox.widget {
    text   = "",
    widget = wibox.widget.textbox,
}
myVolume.font = "FontAwesome 13"

-- local myVolume_tooltip = awful.tooltip {
--     objects        = { myVolume },
--     timer_function = function()
--         local volume = io.popen("wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%d\", $2*100}'"):read("*a")
--         volume = tonumber(volume) or 0  -- Convert to number, default to 0 if nil
--         if volume == 0 then
--             myVolume.text = ""  -- Mute icon when volume is 0%
--         else
--             myVolume.text = ""  -- Unmute icon otherwise
--         end
--         return volume .. "%"  -- Return the volume percentage for the tooltip
--     end,
-- }

-- Volume Level Widget
myVolumeLevel = wibox.widget {
    text   = "100%",  -- Default value
    widget = wibox.widget.textbox,
}
myVolumeLevel.font = "FontAwesome 11"

-- Center the Volume Level Widget
myVolumeLevelCentered = wibox.container.place(myVolumeLevel, 'center', 'center')

myVolume:connect_signal("button::release", function(c, _, _, button)
    if button == 1 then
        awful.spawn.easy_async_with_shell("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", function()
            if c.text == "" then
                c.text = ""
            else
                c.text = ""
            end
            updateVolumeLevel()  -- Update the volume level display
        end)
    elseif button == 3 then
        awful.spawn.easy_async_with_shell("bash ~/Documents/Scripts/paswitch.sh", function() end)
    elseif button == 4 then
        awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%d\", $2*100}' | awk '{if ($1 < 153) print \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+\"}' | sh", function() 
            updateVolumeLevel()  -- Update the volume level display
        end)
    elseif button == 5 then
        awful.spawn.easy_async_with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", function() 
            updateVolumeLevel()  -- Update the volume level display
        end)
    end
end)

-- Function to update the volume level display
function updateVolumeLevel()
    awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local volume = tonumber(stdout:match("(%d+%.?%d*)")) * 100
        myVolumeLevel.text = math.floor(volume) .. "%"  -- Use math.floor to remove decimal
        
        -- Set the mute icon if volume is 0%
        if volume == 0 then
            myVolume.text = ""  -- Mute icon
        else
            myVolume.text = ""  -- Unmute icon
        end
    end)
end

-- Microphone Widget
myMic = wibox.widget {
    text   = "",
    widget = wibox.widget.textbox,
}
myMic.font = "FontAwesome 13"

-- local myMic_tooltip = awful.tooltip {
--     objects        = { myMic },
--     timer_function = function()
--         local volume = io.popen("wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{printf \"%d\", $2*100}'"):read("*a")
--         volume = tonumber(volume) or 0  -- Convert to number, default to 0 if nil
--         if volume == 0 then
--             myMic.text = ""  -- Mute icon when volume is 0%
--         else
--             myMic.text = ""  -- Unmute icon otherwise
--         end
--         return volume .. "%"  -- Return the volume percentage for the tooltip
--     end,
-- }

-- Microphone Level Widget
myMicLevel = wibox.widget {
    text   = "100%",  -- Default value
    widget = wibox.widget.textbox,
}
myMicLevel.font = "FontAwesome 11"

-- Center the Microphone Level Widget
myMicLevelCentered = wibox.container.place(myMicLevel, 'center', 'center')

myMic:connect_signal("button::release", function(c, _, _, button)
    if button == 1 then
        awful.spawn.easy_async_with_shell("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", function()
            if c.text == "" then
                c.text = ""
            else
                c.text = ""
            end
            updateMicLevel()  -- Update the mic level display
        end)
    elseif button == 4 then
        awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{printf \"%d\", $2*100}' | awk '{if ($1 < 153) print \"wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+\"}' | sh", function() 
            updateMicLevel()  -- Update the mic level display
        end)
    elseif button == 5 then
        awful.spawn.easy_async_with_shell("wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-", function() 
            updateMicLevel()  -- Update the mic level display
        end)
    end
end)

-- Function to update the mic level display
function updateMicLevel()
    awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SOURCE@", function(stdout)
        local volume = tonumber(stdout:match("(%d+%.?%d*)")) * 100
        myMicLevel.text = math.floor(volume) .. "%"  -- Use math.floor to remove decimal
        
        -- Set the mute icon if mic volume is 0%
        if volume == 0 then
            myMic.text = ""  -- Mute icon
        else
            myMic.text = ""  -- Unmute icon
        end
    end)
end

-- Call the update functions to set the initial values
updateVolumeLevel()
updateMicLevel()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                         end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                         end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    
    awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

    --awful.tag({ "TERMINAL", "FILES", "BROWSER", "ENTERTAINMENT", "MESSAGES", "EDIT", "GAME", "MAIL", "EXPERIMENT" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using. 
    
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
        
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Adding space especially useful to keep empty middle
	local spacer = wibox.widget.textbox(" ")

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, width = 1920, height = 25 })

    -- Add widgets to the wibox
    s.mywibox:setup {
    {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            wibox.widget.textbox('  '),
            myPowerMenu,
            wibox.widget.textbox(' | '),
            s.mytaglist,
            s.mypromptbox,
        },
        { -- Middle widget
            --s.mytasklist,     -- shows all apps opened in a tag like it would on Windows
            layout = wibox.layout.fixed.horizontal,
            mytextclock,
            --spacer,           -- if nothing's in middle, use this code to maintain clean middle wibar
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout,     -- shows keyboard language in the wibar
            myWifiMenu,
            wibox.widget.textbox(' '),
            myBluetoothMenu,
            wibox.widget.textbox(' | '),
            myVolume,
            wibox.widget.textbox(' '),
            myVolumeLevelCentered,
            wibox.widget.textbox('  '),
            myMic,
            wibox.widget.textbox(' '),
            myMicLevelCentered,
            wibox.widget.textbox(' |  '),
            wibox.widget.systray(),
            wibox.widget.textbox(' '),
            -- s.mylayoutbox,       -- Shows the tiling layout (in my case, i use tile and floating)
        },
    },
        --color = "#ffffff",
        --top = 10,
        --left = 10,
        --right = 10,
        --bottom = 0,
        --margins = 10,
    	widget = wibox.container.margin, 
}
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    --awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
    --          {description = "run prompt", group = "launcher"}),
   
    -- Hotkeys for Applications 
    -- Zen Browser
    awful.key({ modkey },            "b",     function () 
    awful.util.spawn("zen-browser") end,
              {description = "Open a browser (Zen)", group = "joeyboi"}),
   
    -- Mullvad Browser
    awful.key({ modkey },            "z",     function () 
    awful.util.spawn("mullvad-browser") end,
              {description = "Open a browser (Mullvad Browser)", group = "joeyboi"}),

    -- File Manager
    awful.key({ modkey },            "e",     function () 
    awful.util.spawn("pcmanfm") end,
              {description = "Open a file manager (pcmanfm)", group = "joeyboi"}),

    -- Rofi drun
    awful.key({ modkey },            "r",     function () 
    awful.util.spawn("rofi -show drun") end,
              {description = "Opens Rofi's drun", group = "rofi"}),

    -- Rofi emoji
    awful.key({ modkey, "Shift" },            "e",     function () 
    awful.util.spawn("rofi -show emoji") end,
              {description = "Opens Rofi's emoji", group = "rofi"}),
    
    -- Rofi window
    awful.key({ modkey, "Control" },            "e",     function () 
    awful.util.spawn("rofi -show window") end,
              {description = "Opens Rofi's window", group = "rofi"}),

    -- Rofi Power Menu
    awful.key({ modkey, "Shift" },            "p",     function () 
    awful.spawn.with_shell("~/Documents/Scripts/powermenu.sh") end,
              {description = "Rofi Power Menu", group = "joeyboi"}), 
    
    -- Screenshot to ~/Pictures/Screenshots
    awful.key({ modkey, "Shift" },            "s",     function () 
        awful.util.spawn("flameshot gui") end,
                  {description = "Takes a screenshot with Flameshot", group = "joeyboi"}),

     -- Change Audio Outputs between Speaker and Headset
     awful.key({ modkey },            "v",     function ()
         awful.spawn.with_shell("~/Documents/Scripts/paswitch.sh") end,
                   {description = "Changes Output Between Speaker and Headset", group = "Audio"}),

	-- Rofi Wifi Menu
	awful.key({ modkey, "Shift"},		"o",			function ()
		awful.spawn.with_shell("~/.local/share/rofi-wifi-menu/rofi-wifi-menu.sh") end,
		{description = "Rofi Wifi Menu", group = "joeyboi"}),

    ---- Increase volume
    --awful.key({ modkey },            "Up",     function () 
    --awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%") 
    --awful.util.spawn_with_shell("~/Documents/Scripts/volume_osd.sh")
    --end,
              --{description = "Increase the Volume", group = "audio"}), 
    --
    ---- Decrease volume 
    --awful.key({ modkey },            "Down",     function () 
    --awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%") 
    --awful.util.spawn_with_shell("~/Documents/Scripts/volume_osd.sh")
    --end,
              --{description = "Decrease the Volume", group = "audio"}), 
--
    ---- Mute volume
    --awful.key({ modkey },            ".",     function () 
    --awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") 
    --awful.util.spawn_with_shell("~/Documents/Scripts/volume_osd.sh")
    --end,
              --{description = "Mute the Volume", group = "audio"}), 
     
    -- Lua Code	      
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = false})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = false})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart
-- Picom compositor enables automatically
awful.spawn.with_shell("picom")

-- Network Manager Applet
-- awful.spawn.with_shell("nm-applet")

-- Check if volumeicon is running, if not, start it (good to not create new versions of applet)
awful.spawn.with_shell("pgrep -x volumeicon > /dev/null || volumeicon")

-- awful.spawn.with_shell("pgrep -x pasystray > /dev/null || pasystray")

-- Syncthing starts automatically without a browser tab/window opening after booting in
awful.spawn.with_shell("syncthing -no-browser")

-- Applications
--awful.spawn.with_shell("kitty", {tag = })
--awful.spawn.with_shell("zen-brwoser", {tag = })
--awful.spawn.with_shell("thunderbird", {tag = })
--awful.spawn.with_shell("superproductivity", {tag = })
--awful.spawn.with_shell("firefoxpwa site launch 01JARW913PB0JJH95S5FXHHT7E", {tag = })
--awful.spawn.with_shell("firefoxpwa site launch 01JB7TJ7DMQ029WWMEDXEJRC9M", {tag = })
--awful.spawn.with_shell("firefoxpwa site launch 01JARX3DQHCNPBPHW20PZNXPQ8", {tag = })
--awful.spawn.with_shell("steam", {tag = })
-- awful.spawn.with_shell("keepassxc") -- KeePassXC 
--awful.spawn.with_shell("")
