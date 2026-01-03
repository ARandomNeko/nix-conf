{pkgs, ...}: {
  users.users.ritu = {
    isNormalUser = true;
    description = "ARandomNeko";
    shell = pkgs.fish;
    extraGroups = [
      "adbusers"
      "docker"
      "input"
      "libvirtd"
      "lp"
      "networkmanager"
      "plugdev"
      "scanner"
      "video"
      "wheel"
      "kvm"
    ];
  };

  users.mutableUsers = true;
  nix.settings.allowed-users = ["ritu"];
}
