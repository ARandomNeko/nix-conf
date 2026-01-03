# System module lists for different host types
{
  # Desktop configuration (NVIDIA GPU)
  desktop = [
    ./core
    ./desktop/niri.nix
    ./desktop/audio.nix
    ./services
    ./packages.nix
  ];

  # Laptop configuration (hybrid graphics, power management)
  laptop = [
    ./core
    ./desktop/niri.nix
    ./desktop/audio.nix
    ./services
    ./services/laptop.nix
    ./packages.nix
  ];
}

