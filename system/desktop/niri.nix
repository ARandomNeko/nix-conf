{
  pkgs,
  inputs,
  ...
}: {
  # Import niri flake module
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # Enable niri compositor with stable package from cache
  programs.niri = {
    enable = true;
    package = pkgs.niri;  # Use nixpkgs niri instead of flake's (avoids building from source)
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
    gpu-screen-recorder
    xwayland-satellite  # XWayland support for niri
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
