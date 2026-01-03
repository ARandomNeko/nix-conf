{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) intelID nvidiaID;
in {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  services.supergfxd.enable = true;
  services = {
    cloudflare-warp.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    # TLP disabled - using power-profiles-daemon instead (required for Noctalia)
    # power-profiles-daemon is more modern and integrates better with Wayland compositors
    # tlp = {
    #   enable = true;
    #   settings = {
    #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #     CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";
    #     CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    #     CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    #     CPU_MIN_PERF_ON_AC = 0;
    #     CPU_MAX_PERF_ON_AC = 100;
    #     CPU_MIN_PERF_ON_BAT = 0;
    #     CPU_MAX_PERF_ON_BAT = 20;
    #   };
    # };
  };
  # Enable GPU Drivers
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    amdgpuBusID = "${intelID}";
    nvidiaBusID = "${nvidiaID}";
  };

  drivers.intel.enable = false;
  vm.guest-services.enable = false;
}
