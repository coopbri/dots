-- Hyprland Lua config
-- https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

-- https://wiki.hypr.land/Configuring/Basics/Monitors/
-- hl.monitor({ output = "DP-1", mode = "3840x2160@60", position = "auto", scale = 1.5 })
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "auto",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "omni-terminal"
local fileManager = "dolphin"
local browser     = "firefox"
local codeEditor  = "code"
local menu        = "wofi"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME",        "transparent")
hl.env("XCURSOR_SIZE",         "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("LIBVA_DRIVER_NAME",    "iHD")
hl.env("XDG_SESSION_TYPE",     "wayland")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")


-------------------
---- AUTOSTART ----
-------------------

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("flameshot")
    hl.exec_cmd("blueman-applet")

    -- workspace-pinned launches (declarative workspace rules below pin them to workspaces)
    hl.exec_cmd(browser)
    hl.exec_cmd("brave")
    hl.exec_cmd("spotify")
    hl.exec_cmd("thunderbird")
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        layout        = "dwindle",
        allow_tearing = false,
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper = -1,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- Custom bezier + animations (translated from hyprlang)
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default",   style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})


----------------------
---- WINDOW RULES ----
----------------------

-- Pin specific apps to their home workspaces (silent = don't follow focus on launch)
hl.window_rule({
    name      = "pin-firefox-ws1",
    match     = { class = "^firefox$" },
    workspace = "1 silent",
})

hl.window_rule({
    name      = "pin-brave-ws2",
    match     = { class = "^brave-browser$" },
    workspace = "2 silent",
})

hl.window_rule({
    name      = "pin-spotify-ws3",
    match     = { class = "^[Ss]potify$" },
    workspace = "3 silent",
})

hl.window_rule({
    name      = "pin-thunderbird-ws4",
    match     = { class = "^org\\.mozilla\\.Thunderbird$" },
    workspace = "4 silent",
})


---------------
---- BINDS ----
---------------

require("binds")
