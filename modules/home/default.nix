{ inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./bash.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./emoji.nix
    ./fastfetch
    ./gh.nix
    ./ghostty.nix
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./kitty.nix
    ./nvf.nix
    ./helix.nix
    ./rofi
    ./qt.nix
    ./scripts
    ./starship.nix
    ./stylix.nix
    ./swaync.nix
    ./virtmanager.nix
    ./waybar.nix
    ./wlogout
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
    ./emacs.nix
    ./flatpak.nix
  ];
}
