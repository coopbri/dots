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
local fileManager = "/home/brian/.local/bin/sift /home/brian"
local browser     = "firefox"
local codeEditor  = "code"
local menu        = "wofi"


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- Cursor for XWayland apps (e.g. Spotify); match GTK's breeze_cursors/24. A
-- "transparent"/1 combo here previously shrank the cursor to a dot in X11 apps
hl.env("XCURSOR_THEME",        "breeze_cursors")
hl.env("XCURSOR_SIZE",         "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- Force the Breeze widget style for both Qt5 and Qt6 from one env var (sidesteps the
-- qt5ct/qt6ct platform-theme name mismatch). The dark palette itself (Base/AlternateBase,
-- so item-view rows stop alternating light) comes from the BreezeDark color scheme written
-- into ~/.config/kdeglobals, which every KDE Qt app reads directly
hl.env("QT_STYLE_OVERRIDE",    "Breeze")
hl.env("LIBVA_DRIVER_NAME",    "iHD")
hl.env("XDG_SESSION_TYPE",     "wayland")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
-- Arch ships its app menu as arch-applications.menu; without this, KDE's ksycoca
-- finds no applications, so Dolphin can never resolve default apps (always "Open With")
hl.env("XDG_MENU_PREFIX",      "arch-")
-- Mullvad split tunneling mounts a cgroup v1 net_cls controller, which knocks
-- systemd 256+ out of pure-unified mode and breaks transient-unit creation. KIO
-- launches apps as app-*@*.service transient units, so Dolphin can't open mpv et al
-- ("Unit not found"). Forcing fork/exec sidesteps systemd entirely, keeping Mullvad intact
hl.env("_KDE_APPLICATIONS_AS_FORKING", "1")


-------------------
---- AUTOSTART ----
-------------------

-- https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    -- bind the systemd user session to graphical-session.target so xdg-desktop-portal (and flameshot) can start
    hl.exec_cmd("systemctl --user start hyprland-session.target")

    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("swaync")
    -- polkit auth agent so GUI apps can prompt for root
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    -- KDE's kiod6 hosts the kmtpd module that owns the MTP device list. Plasma starts
    -- kiod6 with the session but Hyprland does not, and D-Bus activation fails here
    -- ("unknown unit"), so Dolphin's mtp worker finds zero devices and every phone udi
    -- reads as "does not exist". Starting it here fixes MTP phone access
    hl.exec_cmd("/usr/lib/kf6/kiod6")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("flameshot")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("mullvad-vpn")

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

-- Float + center the Sift portal file picker so it opens as a dialog rather than
-- tiling. Matched on title (the class "sift" is shared with the normal Sift app).
hl.window_rule({
    name  = "float-sift-picker",
    match = { title = "^Sift File Picker$" },
    float = true,
})

hl.window_rule({
    name   = "center-sift-picker",
    match  = { title = "^Sift File Picker$" },
    center = true,
})

-- Grab keyboard focus when the picker shows. It is an already-running D-Bus
-- service whose window is re-shown per request, so the show reads as an
-- xdg-activation request, which the global misc:focus_on_activate=false drops.
-- Scope focus-on-activate to just the picker so you can type the filename at once.
hl.window_rule({
    name              = "focus-sift-picker",
    match             = { title = "^Sift File Picker$" },
    focus_on_activate = true,
})


---------------
---- BINDS ----
---------------

require("binds")
