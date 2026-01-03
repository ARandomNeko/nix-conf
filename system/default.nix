# System module lists for different host types
{
  # Desktop configuration (NVIDIA GPU)
  desktop = [
    # Core
    ./core
    ./core/boot.nix
    ./core/security.nix

    # Nix settings
    ./nix

    # Hardware
    ./hardware/graphics.nix

    # Network
    ./network

    # Desktop environment
    ./desktop/niri.nix
    ./desktop/audio.nix

    # Programs
    ./programs/xdg.nix
    ./programs/qt.nix

    # Services
    ./services

    # Packages
    ./packages.nix
  ];

  # Laptop configuration (hybrid graphics, power management)
  laptop = [
    # Core
    ./core
    ./core/boot.nix
    ./core/security.nix

    # Nix settings
    ./nix

    # Hardware
    ./hardware/graphics.nix

    # Network
    ./network

    # Desktop environment
    ./desktop/niri.nix
    ./desktop/audio.nix

    # Programs
    ./programs/xdg.nix
    ./programs/qt.nix

    # Services
    ./services
    ./services/laptop.nix

    # Packages
    ./packages.nix
  ];
}
