{pkgs, inputs, ...}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  # Required for noctalia features
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Power management (required for noctalia)
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Location services (required for noctalia auto location / night light)
  services.geoclue2.enable = true;

  # Polkit authentication agent
  systemd.user.services.polkit-kde-agent = {
    description = "Polkit KDE Agent";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # D-Bus
  services.dbus.enable = true;

  # Printing
  services.printing.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  # Flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "app.zen_browser.zen"
    ];
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
  };
}

