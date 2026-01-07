{
  pkgs,
  inputs,
  ...
}:
{
  # Noctalia shell configuration with matugen theming
  programs.noctalia-shell = {
    enable = true;

    settings = {
      # General settings
      general = {
        avatarImage = "/home/ritu/.face";
        radiusRatio = 0.2;
      };

      # Location settings
      location.name = "Hyderabad, India";
      # Bar configuration
      bar = {
        density = "normal";
        position = "top";
        showCapsule = true;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 20;
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };

      # Color scheme - use wallpaper colors with matugen
      colorSchemes = {
        useWallpaperColors = true;
        darkMode = true;
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };

      # Matugen templates for application theming
      templates = {
        gtk = true;
        qt = true;
        ghostty = true;
        helix = true;
        yazi = true;
        cava = true;
        niri = true;
        foot = false;
        kitty = false;
        alacritty = false;
      };

      # App launcher
      appLauncher = {
        position = "center";
        sortByMostUsed = true;
        terminalCommand = "ghostty -e";
        viewMode = "list";
        showCategories = true;
        iconMode = "tabler";
      };

      # Wallpaper settings
      wallpaper = {
        mode = "random";
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
      };

      # Notifications
      notifications = {
        enabled = true;
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
      };

      # OSD (volume, brightness overlays)
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
      };

      # Control center
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "ScreenRecorder"; }
            { id = "WallpaperSelector"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
      };

      # Audio settings
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
        externalMixer = "pwvucontrol || pavucontrol";
      };

      # Brightness
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
      };

      # Night light
      nightLight = {
        enabled = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
      };

      # Dock
      dock = {
        enabled = true;
        displayMode = "auto_hide";
        backgroundOpacity = 1;
        size = 1;
        onlySameOutput = true;
        colorizeIcons = false;
        animationSpeed = 1;
      };

      # Session menu
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        showNumberLabels = true;
      };

    };
  };

  # Run noctalia with systemd
  systemd.user.services.noctalia = {
    Unit = {
      Description = "Noctalia Shell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
