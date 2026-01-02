{host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) intelID nvidiaID;
in {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];
  services.cloudflare-warp.enable = true;
  # Enable GPU Drivers
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    amdgpuBusID = intelID;
    nvidiaBusID = nvidiaID;
  };
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
}

