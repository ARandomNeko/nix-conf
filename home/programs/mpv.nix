{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
  ];

  # mpv configuration
  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      vo = "gpu";
      hwdec = "auto-safe";
      volume = 70;
    };
  };

  # Force overwrite existing config files
  xdg.configFile."mpv/mpv.conf".force = true;
}
