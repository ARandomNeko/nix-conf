{
  host,
  username,
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
  # Niri configuration will be in config.kdl
  # This file sets up environment variables and other settings
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "niri";
    GDK_BACKEND = "wayland,x11";
    CLUTTER_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    SDL_VIDEODRIVER = "x11";
    MOZ_ENABLE_WAYLAND = "1";
    # Portal environment variables for Flatpak
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
  };
}

