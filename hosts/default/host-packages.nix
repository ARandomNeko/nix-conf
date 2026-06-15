{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    discord
    obs-studio
  ];
}

