{ inputs, ... }:
{
  # Noctalia shell configuration with matugen theming
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      shell = {
        avatar_path = "/home/ritu/.face";
        corner_radius_scale = 0.2;
        settings_show_advanced = true;
        time_format = "{:%H:%M}";

        panel = {
          launcher_placement = "centered";
          launcher_categories = true;
          launcher_show_icons = true;
          launcher_sort_by_usage = true;
          control_center_placement = "attached";
          open_near_click_control_center = true;
        };
      };

      location = {
        auto_locate = true;
        address = "Hyderabad, India"; # Fallback if auto-detection fails
      };

      bar = {
        default = {
          position = "top";
          thickness = 34;
          margin_ends = 0;
          margin_edge = 0;
          padding = 8;
          widget_spacing = 6;
          background_opacity = 1.0;
          radius = 0;
          shadow = false;
          reserve_space = true;
          capsule = true;
          start = [
            "control-center"
            "network"
            "bluetooth"
          ];
          center = [ "workspaces" ];
          end = [
            "battery"
            "clock"
          ];
        };
      };

      theme = {
        source = "wallpaper";
        mode = "dark";
        wallpaper_scheme = "m3-fruit-salad";
        templates = {
          enable_builtin_templates = true;
          enable_community_templates = false;
          builtin_ids = [
            "gtk3"
            "gtk4"
            "qt"
            "ghostty"
            "helix"
            "cava"
            "niri"
          ];
          user = {
            yazi = {
              input_path = "${inputs.noctalia-legacy-templates}/Assets/Templates/yazi.toml";
              output_path = "$XDG_CONFIG_HOME/yazi/flavors/noctalia.yazi/flavor.toml";
            };
            zed = {
              input_path = "${inputs.noctalia-legacy-templates}/Assets/Templates/zed.json";
              output_path = "$XDG_CONFIG_HOME/zed/themes/noctalia.json";
              post_hook = "mkdir -p \"$HOME/.config/zed\" && touch \"$HOME/.config/zed/settings.json\"";
            };
          };
        };
      };

      wallpaper = {
        enabled = true;
        directory = "/home/ritu/nix-conf/wallpapers";
        transition = [ "fade" ];

        automation = {
          enabled = false;
          interval_seconds = 1800;
          order = "random";
        };
      };

      lockscreen = {
        enabled = true;
      };

      notification = {
        enable_daemon = true;
        position = "top_right";
        layer = "overlay";
        background_opacity = 1.0;
      };

      osd = {
        position = "top_right";
        background_opacity = 1.0;
      };

      dock = {
        enabled = true;
        auto_hide = true;
        reserve_space = false;
        active_monitor_only = true;
        background_opacity = 1.0;
        active_scale = 1.0;
      };

      audio.enable_overdrive = false;
      battery.warning_threshold = 20;

      nightlight = {
        enabled = false;
        temperature_night = 4000;
        temperature_day = 6500;
      };
    };
  };
}
