{
  pkgs,
  inputs,
  ...
}: {
  # Import niri flake module
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Enable niri compositor
  programs.niri.enable = true;

  # XDG portal for screen sharing, file picking, etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # Required for niri/Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # Screenshot and screen recording tools
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    hyprpicker
    swaybg
    swayidle
    brightnessctl
    playerctl
    cliphist
  ];

  # Enable greetd for login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
