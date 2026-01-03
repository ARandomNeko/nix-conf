{pkgs, ...}: {
  # Laptop-specific packages
  environment.systemPackages = with pkgs; [
    # ASUS tools
    asusctl
    supergfxctl

    # Power management
    acpi
    powertop

    # Media (laptop use)
    audacity
    obs-studio

    # Dev tools
    nodejs
  ];
}
