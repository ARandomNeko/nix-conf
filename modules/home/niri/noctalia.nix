{
  inputs,
  username,
  config,
  ...
}: {
  # Import Noctalia home-manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Configure Noctalia shell
  programs.noctalia-shell = {
    enable = true;
    
    # Basic settings
    settings = {
      general = {
        avatarImage = "/home/${username}/.config/face.jpg";
        radiusRatio = 0.2;
      };
      
      bar = {
        density = "compact";
        position = "right";
        showCapsule = false;
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
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      
      # Use Stylix colors if available
      colorSchemes = {
        predefinedScheme = "Noctalia (default)";
        darkMode = true;
        useWallpaperColors = false;
      };
      
      # Enable Niri template for theming
      templates = {
        niri = true;
        gtk = true;
        qt = true;
      };
    };
  };
}



