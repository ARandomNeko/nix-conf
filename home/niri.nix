{pkgs, ...}: {
  # Force overwrite niri config to remove old settings
  xdg.configFile."niri/config.kdl" = {
    force = true;
    text = ''
      // Niri configuration
      // Colors managed by noctalia matugen

      input {
          keyboard {
              xkb {
                  layout "us"
              }
          }

          touchpad {
              tap
              natural-scroll
              accel-speed 0.3
          }

          mouse {
              accel-speed 0.3
          }
      }

      output "eDP-1" {
          mode "2880x1800@60"
          scale 1.2
          variable-refresh-rate
      }

      layout {
          gaps 8
          center-focused-column "never"

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          default-column-width { proportion 0.5; }

          focus-ring {
              width 2
          }

          border {
              off
          }
      }

      prefer-no-csd

      screenshot-path "~/Pictures/Screenshots/%Y-%m-%d_%H-%M-%S.png"

      spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-m" "fill" "-i" "/home/ritu/nix-conf/wallpapers/adrien-olichon-RCAhiGJsUUE-unsplash.jpg"

      binds {
          // Terminal
          Mod+T { spawn "${pkgs.ghostty}/bin/ghostty"; }
          Mod+Return { spawn "${pkgs.ghostty}/bin/ghostty"; }

          // App launcher (noctalia)
          Mod+D { spawn "noctalia" "--toggle-launcher"; }
          Mod+Space { spawn "noctalia" "--toggle-launcher"; }

          // Close window
          Mod+Q { close-window; }
          Mod+Shift+Q { close-window; }

          // Navigation
          Mod+H { focus-column-left; }
          Mod+J { focus-window-down; }
          Mod+K { focus-window-up; }
          Mod+L { focus-column-right; }

          Mod+Left { focus-column-left; }
          Mod+Down { focus-window-down; }
          Mod+Up { focus-window-up; }
          Mod+Right { focus-column-right; }

          // Move windows
          Mod+Shift+H { move-column-left; }
          Mod+Shift+J { move-window-down; }
          Mod+Shift+K { move-window-up; }
          Mod+Shift+L { move-column-right; }

          Mod+Shift+Left { move-column-left; }
          Mod+Shift+Down { move-window-down; }
          Mod+Shift+Up { move-window-up; }
          Mod+Shift+Right { move-column-right; }

          // Workspaces
          Mod+1 { focus-workspace 1; }
          Mod+2 { focus-workspace 2; }
          Mod+3 { focus-workspace 3; }
          Mod+4 { focus-workspace 4; }
          Mod+5 { focus-workspace 5; }
          Mod+6 { focus-workspace 6; }
          Mod+7 { focus-workspace 7; }
          Mod+8 { focus-workspace 8; }
          Mod+9 { focus-workspace 9; }

          Mod+Shift+1 { move-column-to-workspace 1; }
          Mod+Shift+2 { move-column-to-workspace 2; }
          Mod+Shift+3 { move-column-to-workspace 3; }
          Mod+Shift+4 { move-column-to-workspace 4; }
          Mod+Shift+5 { move-column-to-workspace 5; }
          Mod+Shift+6 { move-column-to-workspace 6; }
          Mod+Shift+7 { move-column-to-workspace 7; }
          Mod+Shift+8 { move-column-to-workspace 8; }
          Mod+Shift+9 { move-column-to-workspace 9; }

          // Layout
          Mod+W { maximize-column; }
          Mod+F { fullscreen-window; }
          Mod+C { center-column; }

          Mod+Minus { set-column-width "-10%"; }
          Mod+Equal { set-column-width "+10%"; }

          // Consume/expel
          Mod+BracketLeft { consume-window-into-column; }
          Mod+BracketRight { expel-window-from-column; }

          // Screenshots
          Print { screenshot; }
          Mod+Print { screenshot-screen; }
          Mod+Shift+Print { screenshot-window; }

          // Audio (for noctalia OSD)
          XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
          XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
          XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
          XF86AudioMicMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

          // Brightness - handled by ASUS daemon or use Mod+keys
          Mod+F3 { spawn "brightnessctl" "set" "5%+"; }
          Mod+F2 { spawn "brightnessctl" "set" "5%-"; }

          // Media
          XF86AudioPlay { spawn "playerctl" "play-pause"; }
          XF86AudioNext { spawn "playerctl" "next"; }
          XF86AudioPrev { spawn "playerctl" "previous"; }

          // Power menu
          Mod+Shift+E { spawn "noctalia" "--toggle-session"; }

          // Lock
          Mod+Escape { spawn "noctalia" "--lock"; }

          // Quit niri
          Mod+Shift+Escape { quit; }
      }
    '';
  };
}

