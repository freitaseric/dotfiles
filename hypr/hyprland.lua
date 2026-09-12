-- ============================================================================
-- Hyprland configuration
-- Target: Hyprland 0.56.2 / Arch Linux
-- Machine: Dell Inspiron 3442 - Intel HD 4400 + GeForce 820M
-- Philosophy: lightweight, keyboard-first, compact and easy to evolve
-- ============================================================================

-----------------
-- APPLICATIONS
-----------------

local terminal    = "foot"
local fileManager = "thunar"
local launcher    = "fuzzel"
local browser     = "firefox"
local mainMod     = "SUPER"

-------------
-- MONITORS
-------------

-- Internal panel: 1366x768. Keep scale at 1 on this resolution.
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})

-- Fallback for external displays.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-------------------------
-- ENVIRONMENT VARIABLES
-------------------------

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-------------
-- AUTOSTART
-------------

hl.on("hyprland.start", function()
    -- Export the Wayland session environment to user services / portals.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP && systemctl --user restart hyprpaper.service")

    -- Authentication agent.
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")

    -- Desktop essentials.
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")

    -- Clipboard history. Text + images.
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-----------------
-- LOOK & FEEL
-----------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 8,
        border_size = 2,
        layout      = "dwindle",

        -- Subtle active accent, low-contrast inactive border.
        col = {
            active_border   = "rgba(0f766eff)",
            inactive_border = "rgba(3b4147aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
    },

    decoration = {
        rounding       = 6,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 6,
            render_power = 2,
            color        = "rgba(00000055)",
        },

        -- Disabled deliberately: this notebook is old enough that blur is
        -- mostly decorative GPU work with little practical benefit.
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})

----------------
-- ANIMATIONS
----------------

-- Compact, responsive motion. These are intentionally restrained.
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })

-- Hyprland 0.56.2 generated configs use "dampening".
hl.curve("easy", {
    type      = "spring",
    mass      = 1,
    stiffness = 238.1191,
    dampening = 24.21279333,
})

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.4,  bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 5.0,  spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.4,  spring = "easy",         style = "popin 94%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2.2,  bezier = "linear",       style = "popin 94%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 2.0,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.7,  bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.2,  bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 4.0,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4.0,  bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.8,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2.0,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.6,  bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 2.2,  bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.6,  bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.0,  bezier = "almostLinear", style = "fade" })

-----------
-- LAYOUT
-----------

hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    scrolling = {
        fullscreen_on_one_column = true,
    },
})

--------
-- MISC
--------

hl.config({
    misc = {
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        middle_click_paste         = false,
    },
})

---------
-- INPUT
---------

hl.config({
    input = {
        kb_layout  = "br",
        kb_variant = "abnt2",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = true,
            tap_to_click    = true,
        },
    },
})

-- Three-finger horizontal swipe changes workspaces.
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

----------------
-- KEYBINDINGS
----------------

-- Core apps
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal),    { description = "Open terminal" })
hl.bind(mainMod .. " + SPACE",  hl.dsp.exec_cmd(launcher),    { description = "Open launcher" })
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager), { description = "Open file manager" })
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser),     { description = "Open browser" })

-- Window actions
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({
    mode = "fullscreen",
    action = "toggle",
}), { description = "Toggle fullscreen" })

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(),                    { description = "Toggle pseudotile" })
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"),              { description = "Toggle dwindle split" })

-- Vim-like focus: Super + H/J/K/L
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left"  }), { description = "Focus left" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down"  }), { description = "Focus down" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up"    }), { description = "Focus up" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })

-- Move windows: Super + Shift + H/J/K/L
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left"  }), { description = "Move window left" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down"  }), { description = "Move window down" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up"    }), { description = "Move window up" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }), { description = "Move window right" })

-- Arrow keys mirror the focus controls for convenience.
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))

-- Workspaces 1-10. Key 0 maps to workspace 10.
for i = 1, 10 do
    local key = i % 10

    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }),
        { description = "Focus workspace " .. i }
    )

    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }),
        { description = "Move window to workspace " .. i }
    )
end

-- Scratchpad / special workspace.
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratch"), {
    description = "Toggle scratchpad",
})
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratch" }), {
    description = "Move window to scratchpad",
})

-- Cycle existing workspaces with Super + wheel.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Drag tiled/floating windows without hunting for the title bar.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Lock screen. Chosen to avoid conflicting with Super+L focus-right.
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"), {
    description = "Lock session",
})

-- Session menu / exit. Uses hyprshutdown when available.
hl.bind(mainMod .. " + CTRL + SHIFT + Q",
    hl.dsp.exec_cmd("$HOME/.local/bin/powermenu"),
    { description = "Session / power menu" }
)

-------------------
-- MEDIA / LAPTOP
-------------------

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true }
)

hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true }
)

hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
    { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

---------------
-- SCREENSHOTS
---------------

-- Select an area and annotate it.
hl.bind("Print",
    hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'),
    { description = "Screenshot area and annotate" }
)

-- Select an area and copy it directly to the clipboard.
hl.bind(mainMod .. " + Print",
    hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'),
    { description = "Screenshot area to clipboard" }
)

-- Save the whole screen to ~/Pictures/Screenshots.
hl.bind("SHIFT + Print",
    hl.dsp.exec_cmd('mkdir -p "$HOME/Pictures/Screenshots"; grim "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"'),
    { description = "Save full screenshot" }
)

-------------
-- CLIPBOARD
-------------

-- Clipboard history picker using Fuzzel's dmenu mode.
hl.bind(mainMod .. " + SHIFT + V",
    hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --prompt='Clipboard > ' | cliphist decode | wl-copy"),
    { description = "Clipboard history" }
)

-----------------
-- NOTIFICATIONS
-----------------

hl.bind(mainMod .. " + N",
    hl.dsp.exec_cmd("swaync-client -t"),
    { description = "Toggle notification center" }
)

--------------------------
-- WINDOWS / WINDOW RULES
--------------------------

-- Ignore app-requested maximize events: the compositor owns layout decisions.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Float modal dialogs and keep them centered.
hl.window_rule({
    name  = "float-modal-dialogs",
    match = { modal = true },

    float  = true,
    center = true,
})

-- Common utility windows that are better floating.
hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },

    float  = true,
    center = true,
})

hl.window_rule({
    name  = "float-network-editor",
    match = { class = "^(nm-connection-editor)$" },

    float  = true,
    center = true,
})

-- XWayland helper windows with no class/title should not steal focus.
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- ============================================================================
-- Quick reference
--
-- Super + Return             terminal
-- Super + Space              launcher
-- Super + E                  file manager
-- Super + B                  browser
-- Super + Q                  close
-- Super + F                  fullscreen
-- Super + V                  float/tile
-- Super + P                  pseudotile
-- Super + T                  change dwindle split
--
-- Super + H/J/K/L            focus left/down/up/right
-- Super + Shift + H/J/K/L    move window
--
-- Super + 1..0               workspace 1..10
-- Super + Shift + 1..0       move window to workspace 1..10
-- Super + S                  scratchpad
-- Super + Shift + S          move window to scratchpad
--
-- Super + Ctrl + L           lock
-- Super + Ctrl + Shift + Q   session / power menu
-- Super + Shift + V          clipboard history
-- Super + N                  notifications
--
-- Print                      select + annotate screenshot
-- Super + Print              select + copy screenshot
-- Shift + Print              save full screenshot
-- ============================================================================
