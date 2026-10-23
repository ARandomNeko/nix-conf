{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    discord
    obs-studio
  ];
}
