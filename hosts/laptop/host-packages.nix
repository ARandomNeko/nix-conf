{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    discord
    nodejs
    obs-studio
    asusctl
    supergfxctl
    acpi
    amdctl
    undervolt
  ];
}
