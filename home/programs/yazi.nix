{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yazi
  ];

  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      manager = {
        flavor = "noctalia";
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
  };
}
