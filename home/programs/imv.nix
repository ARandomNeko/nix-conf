{ pkgs, ... }:
{
  home.packages = with pkgs; [
    imv
  ];

  # imv image viewer
  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "000000";
        fullscreen = false;
      };
    };
  };
}
