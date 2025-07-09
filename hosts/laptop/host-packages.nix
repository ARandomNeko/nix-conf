{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    discord
    nodejs
    obs-studio
    asusctl
    supergfxctl
    acpi
    
    # GPU monitoring tools for btop
    nvtopPackages.nvidia  # GPU monitoring tool
    mesa-demos          # OpenGL utilities (includes glxinfo)
    vulkan-tools        # Vulkan utilities
  ];
}
