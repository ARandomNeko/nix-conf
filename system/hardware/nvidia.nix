{
  config,
  lib,
  pkgs,
  ...
}: {
  # Enable NVIDIA drivers
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # nouveau open source driver). Support is limited to the Turing and later 
    # architectures. Full list of supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Package selection
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Prime configuration
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus ID of the NVIDIA GPU
      nvidiaBusId = "PCI:1:0:0";
      # Bus ID of the AMD iGPU
      amdgpuBusId = "PCI:101:0:0";
    };
  };

  # ASUS G14 specific services
  services.asusd.enable = true;
  services.supergfxd.enable = true;

  # Additional packages for ASUS G14
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];
}
