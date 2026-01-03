{ pkgs, host, lib, config, username, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) 
    extraMonitorSettings keyboardLayout;
    
  # Kaku's quickshell wrapper script
  qs = "${pkgs.quickshell}/bin/qs";
in {
  home.packages = with pkgs; [
    niri
    xwayland-satellite
    quickshell
    # Kaku/QuickShell dependencies
    accountsservice
    brightnessctl
    cava
    cliphist
    ddcutil
    material-symbols
    swww
    wl-clipboard
    wget
    matugen
  ];
  
  # Niri configuration
  xdg.configFile."niri/config.kdl".text = ''

    input {
        keyboard {
            xkb {
                layout "${keyboardLayout}"
            }
        }
        
        touchpad {
            tap
            dwt
            dwtp
            natural-scroll
            click-method "clickfinger"
        }
        
        mouse {
        }
        
        focus-follows-mouse max-scroll-amount="90%"
        warp-mouse-to-focus
        workspace-auto-back-and-forth
    }
    
    layout {
        gaps 6
        center-focused-column "on-overflow"
        always-center-single-column
        
        preset-column-widths {
            proportion 0.25
            proportion 0.5
            proportion 0.75
            proportion 1.0
        }
        
        default-column-width { proportion 0.5; }
        
        focus-ring {
            off
        }
        
        border {
            width 2
        }
        
        shadow {
            off
        }
        
        tab-indicator {
            hide-when-single-tab
            place-within-column
            position "left"
            corner-radius 20.0
            gap -12.0
            gaps-between-tabs 10.0
            width 4.0
        }
    }
    
    ${extraMonitorSettings}
    
    prefer-no-csd
    
    screenshot-path "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png"
    
    hotkey-overlay {
        skip-at-startup
    }
    
    // Startup applications
    spawn-at-startup "xwayland-satellite"
    spawn-at-startup "wl-paste" "--watch" "cliphist" "store"
    spawn-at-startup "wl-paste" "--type" "text" "--watch" "cliphist" "store"
    spawn-at-startup "qs" "-c" "noctalia"
    spawn-at-startup "niri-refresh-switch"
    
    environment {
        QT_QPA_PLATFORM "wayland"
        MOZ_ENABLE_WAYLAND "1"
        XDG_CURRENT_DESKTOP "niri"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        NIXOS_OZONE_WL "1"
        GTK_USE_PORTAL "1"
        QT_QPA_PLATFORMTHEME "qt6ct"
        WLR_RENDERER "vulkan"
        WLR_NO_HARDWARE_CURSORS "1"
    }
    
    cursor {
        xcursor-size 20
        xcursor-theme "Bibata-Original-Ice"
    }
    
    overview {
        backdrop-color "transparent"
    }
    
    gestures {
        hot-corners
    }
    
    binds {
        // ===== Media/Volume/Brightness (Kaku quickshell) =====
        XF86AudioPlay allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "media" "playPause"; }
        XF86AudioStop allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "media" "stop"; }
        XF86AudioNext allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "media" "next"; }
        XF86AudioPrev allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "media" "previous"; }
        XF86AudioMute allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "volume" "muteOutput"; }
        XF86AudioMicMute allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "volume" "muteInput"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "volume" "decrease"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "brightness" "increase"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "qs" "-c" "noctalia" "ipc" "call" "brightness" "decrease"; }
        
        // ===== Launcher & Utilities (Kaku quickshell) =====
        Ctrl+Alt+L { spawn "qs" "-c" "noctalia" "ipc" "call" "lockScreen" "lock"; }
        Mod+V { spawn "qs" "-c" "noctalia" "ipc" "call" "launcher" "clipboard"; }
        Mod+E { spawn "qs" "-c" "noctalia" "ipc" "call" "launcher" "emoji"; }
        Mod+U { spawn "qs" "-c" "noctalia" "ipc" "call" "settings" "toggle"; }
        Mod+D { spawn "qs" "-c" "noctalia" "ipc" "call" "launcher" "toggle"; }
        Mod+Space { spawn "qs" "-c" "noctalia" "ipc" "call" "launcher" "toggle"; }
        Alt+Space { spawn "qs" "-c" "noctalia" "ipc" "call" "launcher" "toggle"; }
        
        Mod+Shift+Slash { show-hotkey-overlay; }
        
        // Terminal
        Mod+T { spawn "ghostty"; }
        Mod+Return { spawn "ghostty"; }
        
        // Screenshots
        Mod+S { screenshot; }
        Print { screenshot-screen; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
        Mod+Shift+S { screenshot; }
        
        // Window management
        Mod+Q { close-window; }
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { toggle-window-floating; }
        Mod+C { center-column; }
        Mod+W { toggle-column-tabbed-display; }
        Mod+Tab { switch-focus-between-floating-and-tiling; }
        
        // Navigation
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }
        
        // Move windows
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
        
        // Monitor navigation
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
        
        // Workspace navigation
        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
        
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
        
        // Column management
        Mod+Comma  { consume-window-into-column; }
        Mod+Period { expel-window-from-column; }
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        
        // Sizing
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }
        
        // System
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        Mod+Shift+Ctrl+T { toggle-debug-tint; }
    }

    // Include Kaku's noctalia colors if they exist
    // include "/home/${username}/.config/niri/noctalia.kdl"
  '';
  
  # Clone noctalia quickshell config during activation
  home.activation.cloneNoctalia = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    NOCTALIA_DIR="$HOME/.config/noctalia"
    
    if [ ! -d "$NOCTALIA_DIR" ]; then
      echo "Cloning noctalia quickshell config..."
      ${pkgs.git}/bin/git clone https://github.com/linuxmobile/kaku.git /tmp/kaku-clone 2>/dev/null || true
      if [ -d "/tmp/kaku-clone" ]; then
        # Look for quickshell config in kaku repo - adjust path as needed
        mkdir -p "$NOCTALIA_DIR"
        echo "Noctalia directory created at $NOCTALIA_DIR"
        rm -rf /tmp/kaku-clone
      fi
    fi
  '';
}
