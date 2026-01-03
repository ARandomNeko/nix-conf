{
  pkgs,
  username,
  host,
  config,
  ...
}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    terminal
    extraMonitorSettings
    keyboardLayout
    ;
in {
  home.packages = with pkgs; [
    swww
    grim
    slurp
    wl-clipboard
    swappy
    brightnessctl
    # Niri compositor
    niri
    # Noctalia and Quickshell are installed via home-manager module
  ];
  
  # Niri configuration - generate config.kdl from template
  xdg.configFile."niri/config.kdl".text = ''
    // Niri configuration file
    // Generated from Nix configuration

    // Monitor configuration (Niri uses output blocks, not single-line monitor settings)
    ${if extraMonitorSettings != "" then 
      let
        # Parse the monitor settings: "eDP-1 2880x1800@60 1.2" -> output "eDP-1" { mode "2880x1800@60"; scale 1.2; }
        # Split by space and extract monitor name, resolution, and scale
        splitResult = builtins.split " " extraMonitorSettings;
        # builtins.split returns [before, match, after, match, ...] so we need to extract strings
        parts = builtins.filter (x: builtins.isString x && x != "") splitResult;
        monitorName = builtins.elemAt parts 0;
        resolution = builtins.elemAt parts 1;
        scale = if builtins.length parts > 2 then builtins.elemAt parts 2 else "1.0";
      in ''
        output "${monitorName}" {
            mode "${resolution}"
            scale ${scale}
        }
      ''
    else "// Using default monitor settings"}

    // Input configuration - simplified for now
    // Note: Niri configuration structure may differ - this is a minimal working config
    input {
      xkb {
        layout "${keyboardLayout}";
        options "grp:alt_caps_toggle";
      }
      repeat-delay 300;
      repeat-rate 30;
      touchpad {
        tap false;
        natural-scroll true;
        disable-while-typing true;
        scroll-factor 0.8;
      }
      follow-cursor true;
      cursor-zoom 1.0;
    }

    // Layout configuration
    layout {
      default-column-width 600;
      center-focused-column true;
      center-focused-column-max-width 1200;
      gaps 8;
    }

    // Window rules - Niri uses window-rule with match directives
    window-rule {
      match app-id="pavucontrol"
      open-floating true
    }
    window-rule {
      match app-id="rofi"
      open-floating true
    }

    // Keybindings
    key-bindings {
      // Mod key
      mod "Mod4"; // Super key
      
      // Terminal
      "Mod4+Return" { spawn "${terminal}"; }
      
      // Application launcher
      "Mod4+Shift+Return" { spawn "rofi-launcher"; }
      
      // Close window
      "Mod4+Q" { close-focused-window; }
      
      // Fullscreen
      "Mod4+F" { toggle-fullscreen; }
      
      // Floating
      "Mod4+Shift+F" { toggle-floating; }
      
      // Focus movement
      "Mod4+Left" { focus-column-left; }
      "Mod4+Right" { focus-column-right; }
      "Mod4+Up" { focus-window-up; }
      "Mod4+Down" { focus-window-down; }
      "Mod4+H" { focus-column-left; }
      "Mod4+L" { focus-column-right; }
      "Mod4+K" { focus-window-up; }
      "Mod4+J" { focus-window-down; }
      
      // Move window
      "Mod4+Shift+Left" { move-column-left; }
      "Mod4+Shift+Right" { move-column-right; }
      "Mod4+Shift+Up" { move-window-up; }
      "Mod4+Shift+Down" { move-window-down; }
      "Mod4+Shift+H" { move-column-left; }
      "Mod4+Shift+L" { move-column-right; }
      "Mod4+Shift+K" { move-window-up; }
      "Mod4+Shift+J" { move-window-down; }
      
      // Workspace switching
      "Mod4+1" { focus-workspace "1"; }
      "Mod4+2" { focus-workspace "2"; }
      "Mod4+3" { focus-workspace "3"; }
      "Mod4+4" { focus-workspace "4"; }
      "Mod4+5" { focus-workspace "5"; }
      "Mod4+6" { focus-workspace "6"; }
      "Mod4+7" { focus-workspace "7"; }
      "Mod4+8" { focus-workspace "8"; }
      "Mod4+9" { focus-workspace "9"; }
      "Mod4+0" { focus-workspace "10"; }
      
      // Move window to workspace
      "Mod4+Shift+1" { move-window-to-workspace "1"; }
      "Mod4+Shift+2" { move-window-to-workspace "2"; }
      "Mod4+Shift+3" { move-window-to-workspace "3"; }
      "Mod4+Shift+4" { move-window-to-workspace "4"; }
      "Mod4+Shift+5" { move-window-to-workspace "5"; }
      "Mod4+Shift+6" { move-window-to-workspace "6"; }
      "Mod4+Shift+7" { move-window-to-workspace "7"; }
      "Mod4+Shift+8" { move-window-to-workspace "8"; }
      "Mod4+Shift+9" { move-window-to-workspace "9"; }
      "Mod4+Shift+0" { move-window-to-workspace "10"; }
      
      // Workspace navigation
      "Mod4+Control+Right" { focus-workspace-or-monitor "next"; }
      "Mod4+Control+Left" { focus-workspace-or-monitor "previous"; }
      
      // Media keys
      "XF86AudioRaiseVolume" { spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"; }
      "XF86AudioLowerVolume" { spawn "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"; }
      "XF86AudioMute" { spawn "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      "XF86AudioPlay" { spawn "playerctl play-pause"; }
      "XF86AudioPause" { spawn "playerctl play-pause"; }
      "XF86AudioNext" { spawn "playerctl next"; }
      "XF86AudioPrev" { spawn "playerctl previous"; }
      "XF86MonBrightnessDown" { spawn "brightnessctl -d amdgpu_bl0 set 5%-"; }
      "XF86MonBrightnessUp" { spawn "brightnessctl -d amdgpu_bl0 set +5%"; }
      
      // Screenshot
      "Mod4+S" { spawn "screenshootin"; }
      
      // Color picker (may need alternative for niri)
      "Mod4+C" { spawn "hyprpicker -a"; }
      
      // Browser
      "Mod4+W" { spawn "app.zen_browser.zen"; }
      
      // Emoji picker
      "Mod4+E" { spawn "emopicker9000"; }
      
      // Wallpaper setter
      "Mod4+Alt+W" { spawn "wallsetter"; }
      
      // Notification center
      "Mod4+Shift+N" { spawn "swaync-client -rs"; }
    }

    // Spawn at startup
    spawn-at-startup {
      // Start Noctalia shell (managed by home-manager)
      "qs" "-c" "noctalia-shell";
      
      // Start wallpaper daemon
      "swww" "init";
      
      // Set wallpaper
      "swww" "img" "/home/${username}/Pictures/Wallpapers/zaney-wallpaper.jpg";
      
      // Start notification daemon (Noctalia has built-in notifications, but keeping swaync for compatibility)
      "swaync";
      
      // Start network manager applet (Noctalia has WiFi/Bluetooth widgets, but keeping for compatibility)
      "nm-applet" "--indicator";
      
      // Start polkit agent
      "lxqt-policykit-agent";
      
      // Update environment
      "dbus-update-activation-environment" "--all" "--systemd" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP";
      "systemctl" "--user" "import-environment" "WAYLAND_DISPLAY" "XDG_CURRENT_DESKTOP";
    }

    // Animations
    animations {
      slowdown 1.0;
      windows {
        enabled true;
        duration 200;
        easing "ease-out-cubic";
      }
      workspaces {
        enabled true;
        duration 200;
        easing "ease-out-cubic";
      }
    }

    // Focus ring
    focus-ring {
      enabled true;
      color "#${config.lib.stylix.colors.base08}";
      width 2;
      active {
        color "#${config.lib.stylix.colors.base0C}";
        width 2;
      }
    }

    // Border
    border {
      width 2;
      color {
        active "#${config.lib.stylix.colors.base08}";
        inactive "#${config.lib.stylix.colors.base01}";
      }
      radius 10;
    }

    // Corner radius
    corner-radius 10;
  '';
  
  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../../wallpapers;
    recursive = true;
  };
  # face.jpg removed - not needed
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
  
  # Noctalia is now installed via home-manager module (see noctalia.nix)
}

