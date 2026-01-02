{ pkgs, host, lib, config, username, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) 
    extraMonitorSettings keyboardLayout;
in {
  home.packages = with pkgs; [
    niri
    xwayland-satellite
  ];
  
  # Niri configuration
  xdg.configFile."niri/config.kdl".text = ''
    // Include DMS-managed configurations at the top
    include "/home/${username}/.config/niri/dms/colors.kdl";
    include "/home/${username}/.config/niri/dms/binds.kdl";
    include "/home/${username}/.config/niri/dms/wpblur.kdl";
    include "/home/${username}/.config/niri/dms/alttab.kdl";

    input {
        keyboard {
            xkb {
                layout "${keyboardLayout}"
            }
        }
        
        touchpad {
            tap
            // tap-drag is disabled by default (omitted)
            dwt
            dwtp
            natural-scroll
            click-method "clickfinger"
        }
        
        mouse {
            // natural-scroll disabled - inverted/traditional scroll direction
        }
    }
    
    layout {
        gaps 8
        center-focused-column "on-overflow"
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        
        default-column-width { proportion 0.5; }
    }
    
    ${extraMonitorSettings}
    
    prefer-no-csd
    
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
    
    hotkey-overlay {
        skip-at-startup
    }
    
    // XWayland support for X11 apps (Steam, etc.)
    spawn-at-startup "xwayland-satellite"
    
    // DMS autostart - use the Go tool to launch the shell and manage the session
    spawn-at-startup "dms" "run"
    
    // Optional: Enable automatic refresh rate switching for battery savings
    // Switches to 60Hz on battery, 120Hz on AC power
    spawn-at-startup "niri-refresh-switch"
    
    environment {
        QT_QPA_PLATFORM "wayland"
        MOZ_ENABLE_WAYLAND "1"
        XDG_CURRENT_DESKTOP "niri"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        NIXOS_OZONE_WL "1"
        GTK_USE_PORTAL "1"
        // DISPLAY is set automatically by Niri's xwayland block
    }
    
    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }
        
        Mod+T { spawn "ghostty"; }
        Mod+Space { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
        Mod+S { spawn "screenshot-area"; }
        Mod+Q { close-window; }
        Mod+Shift+C { spawn "dms" "ipc" "call" "control-center" "toggle"; }
        Mod+X { spawn "dms" "ipc" "call" "powermenu" "toggle"; }
        
        XF86MonBrightnessUp allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5" ""; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5" ""; }
        
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }
        
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }
        Mod+Ctrl+H     { move-column-left; }
        Mod+Ctrl+J     { move-window-down; }
        Mod+Ctrl+K     { move-window-up; }
        Mod+Ctrl+L     { move-column-right; }
        
        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }
        
        Mod+Shift+Left  { focus-monitor-left; }
        Mod+Shift+Down  { focus-monitor-down; }
        Mod+Shift+Up    { focus-monitor-up; }
        Mod+Shift+Right { focus-monitor-right; }
        Mod+Shift+H     { focus-monitor-left; }
        Mod+Shift+J     { focus-monitor-down; }
        Mod+Shift+K     { focus-monitor-up; }
        Mod+Shift+L     { focus-monitor-right; }
        
        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }
        
        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U         { move-column-to-workspace-down; }
        Mod+Ctrl+I         { move-column-to-workspace-up; }
        
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }
        
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }
        
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }
        
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }
        
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
        
        Mod+Shift+E { quit; }
        
        Mod+Shift+P { power-off-monitors; }
        
        Mod+Shift+Ctrl+T { toggle-debug-tint; }
    }
  '';
}
