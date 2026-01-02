let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/graphics.nix
    ./hardware/fwupd.nix

    ./network/default.nix

    ./programs

    ./services
    ./services/flatpak.nix
    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/xdg-portal-fix.nix
  ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix
      ./hardware/nvidia.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop;
}
