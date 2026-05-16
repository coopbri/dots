-- Keybindings
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

-- Programs (kept in sync with hyprland.lua)
local terminal    = "omni-terminal"
local fileManager = "dolphin"
local browser     = "firefox"
local codeEditor  = "code"
local menu        = "wofi"


------------------------
---- WINDOW ACTIONS ----
------------------------

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only


-----------------------
---- APP LAUNCHERS ----
-----------------------

hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd(menu))
hl.bind("ALT + SPACE",          hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C",      hl.dsp.exec_cmd(codeEditor))


-----------------
---- FOCUS ------
-----------------

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))


--------------------
---- WORKSPACES ----
--------------------

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,                 hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,         hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key,           hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))


------------------------
---- MOUSE DRAG/RES ----
------------------------

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


---------------
---- AUDIO ----
---------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),                           { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),                                 { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),                             { locked = true })


--------------------
---- SCREENSHOT ----
--------------------

hl.bind(mainMod .. " + Print",       hl.dsp.exec_cmd('grim -g "$(slurp)"'))
hl.bind(mainMod .. " + ALT + Print", hl.dsp.exec_cmd('grimblast --freeze copysave area ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).png'))


-------------------
---- CLIPBOARD ----
-------------------

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("sh -c 'cliphist list | wofi --dmenu | cliphist decode | wl-copy'"))
