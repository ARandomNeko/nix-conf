{...}: {
  stylix.targets = {
    waybar.enable = false;
    rofi.enable = false;
    # Niri doesn't use stylix integration like hyprland
    hyprlock.enable = false;
    ghostty.enable = true;
    neovim.enable = true;
    nvf.enable = false; # Disable nvf theming to avoid conflicts
    kitty.enable = true;
    helix.enable = true;
    yazi.enable = true;
    gtk.enable = true;
  };
}
