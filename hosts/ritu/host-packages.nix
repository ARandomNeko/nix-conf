{pkgs, ...}: {
  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    # Media production
    audacity
    obs-studio

    # Dev tools
    nodejs

    # NVIDIA tools
    nvtopPackages.nvidia
  ];
}
