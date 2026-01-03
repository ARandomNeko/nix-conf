{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zathura
  ];

  # Zathura PDF viewer
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      recolor = true;
    };
  };
}
