{
  config,
  pkgs,
  lib,
  ...
}: {
  boot = {
    bootspec.enable = true;

    initrd = {
      systemd.enable = true;
    };

    # Filesystem support
    supportedFilesystems = ["ntfs" "exfat"];

    # Use Linux 6.18 (mkForce to override nixos-hardware)
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;

    # Quiet boot
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Plymouth boot splash
    plymouth.enable = true;

    # Use tmpfs for /tmp
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };
  };

  # Move nix-daemon tmp to /var/tmp (more space for large builds)
  systemd.services.nix-daemon = {
    environment = {
      TMPDIR = "/var/tmp";
    };
  };

  # CPU power management tools
  environment.systemPackages = [config.boot.kernelPackages.cpupower];
}

