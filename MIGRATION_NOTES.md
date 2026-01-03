# Migration from Hyprland to Niri

This document outlines the changes made to migrate from Hyprland to Niri with Noctalia and Quickshell.

## Changes Made

### 1. Created Niri Module
- New module at `modules/home/niri/` with:
  - `default.nix` - Module imports
  - `niri.nix` - Main Niri configuration and packages
  - `config.nix` - Environment variables and settings
  - `noctalia.nix` - Noctalia home-manager module configuration

### 1a. Added Noctalia Flake Input
- Added `noctalia` input to `flake.nix` following the [official NixOS documentation](https://docs.noctalia.dev/getting-started/nixos/)
- Noctalia is now installed via the official home-manager module instead of manual installation

### 2. Updated Core Files
- **modules/home/default.nix**: Changed import from `./hyprland` to `./niri`
- **modules/core/services.nix**: Updated greetd to launch `niri` instead of `Hyprland`
- **modules/core/xdg.nix**: Changed from `xdg-desktop-portal-hyprland` to `xdg-desktop-portal-wlr`
- **modules/home/xdg.nix**: Updated portal configuration to use `wlr` instead of `hyprland`
- **modules/core/system.nix**: Removed Hyprland cache references

### 3. Updated Waybar
- Changed `hyprland/workspaces` to `wlr/workspaces`
- Changed `hyprland/window` to `wlr/window`
- Updated workspace scroll commands to use `niri msg` commands
- Note: Since you're using Noctalia which provides its own bar/panel, you may want to disable Waybar entirely

### 4. Updated Variables
- All `variables.nix` files now reference "Niri Settings" instead of "Hyprland Settings"
- Monitor settings format changed (simplified for Niri's KDL format)

### 5. Updated Scripts
- **keybinds.nix**: Updated to read from `~/.config/niri/config.kdl` instead of Hyprland config

## Next Steps

### 1. Update Flake Lock

First, update your flake lock to include the new Noctalia input:
```bash
nix flake update
```

### 2. Rebuild Your System

```bash
sudo nixos-rebuild switch --flake .#ritu
# or for laptop:
sudo nixos-rebuild switch --flake .#laptop
```

### 3. Noctalia Installation

Noctalia is now installed via the official NixOS/home-manager module! The configuration is in `modules/home/niri/noctalia.nix`.

The module automatically:
- Installs Noctalia and Quickshell packages
- Sets up the configuration directory
- Configures Noctalia settings
- Enables Niri template for theming

### 4. Required Services

The following services are automatically enabled for Noctalia features:
- `networking.networkmanager.enable` - For WiFi widget
- `hardware.bluetooth.enable` - For Bluetooth widget  
- `services.power-profiles-daemon.enable` - For power profile switching
- `services.upower.enable` - For battery monitoring

These are configured in `modules/core/services.nix`.

### 5. Optional: Disable Waybar

Since Noctalia provides its own bar/panel, you may want to disable Waybar:
- Comment out or remove `./waybar.nix` from `modules/home/default.nix`
- Or set `programs.waybar.enable = false;` in the waybar module

### 6. Customize Noctalia Configuration

Edit `modules/home/niri/noctalia.nix` to customize:
- Bar widgets and layout
- Color schemes (can integrate with Stylix)
- Control center settings
- Dock configuration
- Notification settings
- And much more!

See the [Noctalia NixOS documentation](https://docs.noctalia.dev/getting-started/nixos/) for all available options.

### 7. Customize Niri Configuration

Edit `modules/home/niri/niri.nix` to customize:
- Keybindings
- Window rules
- Layout settings
- Animations
- Border and focus ring colors

The configuration is generated as `~/.config/niri/config.kdl` from the Nix module.

## Key Differences from Hyprland

1. **Configuration Format**: Niri uses KDL (KDL Document Language) instead of Hyprland's config format
2. **Window Management**: Niri uses a scrollable-tiling layout (columns on horizontal strip) vs Hyprland's traditional tiling
3. **Bar/Panel**: Noctalia provides the desktop shell/bar instead of Waybar
4. **Portal**: Uses `wlr` portal instead of `hyprland` portal

## Troubleshooting

### Noctalia not starting
- Verify the `spawn-at-startup` command in `config.kdl` is correct (should be `"qs" "-c" "noctalia-shell"`)
- Check that the home-manager module is properly imported in `modules/home/niri/noctalia.nix`
- Check logs: `journalctl --user -u niri` or check `~/.local/share/niri/log`
- Verify Noctalia package is installed: `nix profile list | grep noctalia`

### Waybar not working
- Niri may not fully support Waybar's wlr modules
- Consider disabling Waybar and using Noctalia's built-in bar

### Keybindings not working
- Check `~/.config/niri/config.kdl` syntax
- Verify key names are correct (Niri uses different key names than Hyprland)
- Test with `niri msg action <action-name>`

## Additional Resources

- [Niri Documentation](https://github.com/YaLTeR/niri/wiki)
- [Noctalia Documentation](https://docs.noctalia.dev/)
- [Quickshell Documentation](https://github.com/Quickshell/quickshell)

