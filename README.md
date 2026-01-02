# NixOS Configuration with Niri + DankMaterialShell

This is a NixOS configuration using the **Niri** scrolling window compositor and **DankMaterialShell** (QuickShell-based desktop shell) for a modern, beautiful desktop environment.

## What Changed from Previous Config

### Replaced Components

**Removed:**
- Hyprland compositor → **Niri** (scrolling window manager)
- Waybar → **DankMaterialShell panels**
- Rofi launcher → **DankMaterialShell launcher**
- SwayNC notifications → **DankMaterialShell notifications**
- Wlogout → **DankMaterialShell power modal**

**Kept:**
- All system configuration (boot, drivers, hardware, networking)
- All profiles (nvidia, nvidia-laptop, amd, intel, vm)
- Terminal emulators (Ghostty, Kitty)
- Shell configuration (Zsh, Bash, Starship)
- Text editors (Helix, Neovim/nvf, Emacs)
- Git, direnv, yazi, btop, bat, and other CLI tools
- Flatpak configuration
- GTK/QT theming (now integrated with matugen)

## Features

### Niri Compositor
- **Scrolling paradigm**: Windows scroll horizontally like an infinite canvas
- Smooth animations and gestures
- Per-workspace horizontal strips
- Better for ultrawide and multi-monitor setups
- Keybindings similar to i3/sway with Mod key

### DankMaterialShell
- Beautiful Material Design-inspired UI
- Dynamic theming with **matugen** (generates themes from wallpapers)
- Integrated panels, dock, launcher, notifications, and system controls
- Built with QuickShell (QML-based)
- Auto-theming for GTK, QT, terminals, and Firefox

### Full Theme Integration
- **Matugen** generates color schemes from wallpapers
- GTK 3/4 apps automatically themed
- QT apps themed (with qt6ct)
- Terminal colors (Ghostty, Kitty) sync with theme
- Firefox can be themed with pywalfox or material-fox

## Directory Structure

```
nixos-config/
├── flake.nix              # Main flake definition
├── modules/
│   ├── core/              # System-level configuration
│   │   ├── boot.nix
│   │   ├── fonts.nix
│   │   ├── hardware.nix
│   │   ├── packages.nix   # System packages (includes niri, fuzzel)
│   │   ├── services.nix   # Greetd launches niri-session
│   │   ├── xdg.nix        # XDG portals for Niri
│   │   └── ...
│   ├── drivers/           # GPU drivers and hardware clock
│   └── home/              # Home-manager user configuration
│       ├── niri.nix       # Niri compositor config
│       ├── dankmaterialshell.nix  # DankMaterialShell setup
│       ├── gtk.nix        # GTK with matugen CSS imports
│       ├── ghostty.nix    # Terminal with matugen theme
│       └── ...
├── hosts/
│   ├── ritu/              # Desktop host
│   ├── laptop/            # Laptop host
│   └── default/           # Template host
└── profiles/
    ├── nvidia/            # Desktop Nvidia profile
    ├── nvidia-laptop/     # Laptop with Nvidia Prime
    ├── amd/               # AMD GPU profile
    ├── intel/             # Intel GPU profile
    └── vm/                # Virtual machine profile
```

## Installation & Rebuild

### First Time Setup

1. **Update flake inputs** (optional):
   ```bash
   cd ~/nixos-config
   nix flake update
   ```

2. **Rebuild system** for your host:
   ```bash
   sudo nixos-rebuild switch --flake ~/nixos-config#ritu
   # OR for laptop:
   sudo nixos-rebuild switch --flake ~/nixos-config#laptop
   ```

3. **Logout and select Niri** session from greetd/tuigreet

4. **Launch DankMaterialShell** (should auto-start):
   ```bash
   dms
   ```

### Updating Configuration

After editing any `.nix` files:

```bash
# Using nh (built-in helper)
nh os switch --hostname ritu

# OR manually
sudo nixos-rebuild switch --flake ~/nixos-config#ritu
```

## Niri Keybindings

All keybindings use `Mod` (Super/Windows key by default):

### Window Management
- `Mod+T` - Open terminal (Ghostty)
- `Mod+D` - Open launcher (Fuzzel fallback, DMS launcher preferred)
- `Mod+Q` - Close window
- `Mod+H/J/K/L` or Arrow keys - Focus windows/columns
- `Mod+Ctrl+H/J/K/L` - Move windows/columns
- `Mod+Comma/Period` - Consume/expel windows into column

### Workspaces
- `Mod+1-9` - Switch to workspace
- `Mod+Ctrl+1-9` - Move window to workspace
- `Mod+U/I` or `Page_Up/Down` - Navigate workspaces vertically

### Window Sizing
- `Mod+R` - Cycle preset column widths
- `Mod+F` - Maximize column
- `Mod+Shift+F` - Fullscreen window
- `Mod+C` - Center column
- `Mod+-/=` - Decrease/increase column width
- `Mod+Shift+-/=` - Decrease/increase window height

### Screenshots
- `Print` - Screenshot selection
- `Ctrl+Print` - Screenshot screen
- `Alt+Print` - Screenshot window

### System
- `Mod+Shift+E` - Quit Niri
- `Mod+Shift+P` - Power off monitors
- `Mod+Shift+/` - Show hotkey overlay

Full config: `~/.config/niri/config.kdl`

## DankMaterialShell Configuration

### Settings Location
- `~/.config/DankMaterialShell/settings.json` - Main settings
- Automatic clone/update on system rebuild
- Settings can be changed via DMS UI (click settings in panel)

### Theming with Matugen

1. **Set a wallpaper** to generate theme:
   ```bash
   matugen image /path/to/wallpaper.jpg
   ```

2. **Theme files generated** at:
   - `~/.config/gtk-3.0/dank-colors.css`
   - `~/.config/gtk-4.0/dank-colors.css`
   - `~/.config/qt6ct/colors/matugen.conf`
   - `~/.config/ghostty/config-dankcolors`
   - `~/.config/kitty/dank-theme.conf`

3. **Reload applications** or restart to apply

### Calendar Integration (Optional)

For dashboard calendar widget:

```bash
# Install sync tools (already in config)
vdirsyncer discover  # Follow prompts for Google/Office365
vdirsyncer sync
khal configure

# Add to crontab for auto-sync
crontab -e
# Add: */5 * * * * /usr/bin/vdirsyncer sync
```

### Firefox Theming (Optional)

**Option 1 - Pywalfox:**
```bash
# Extension already installed in config
# In Firefox, install pywalfox extension
# Create symlink:
ln -sf ~/.cache/wal/dank-pywalfox.json ~/.cache/wal/colors.json
```

**Option 2 - Material Fox:**
See DankMaterialShell docs for setup instructions.

## Host-Specific Configuration

### For Desktop (ritu)
Edit `hosts/ritu/variables.nix`:
- `extraMonitorSettings` - Niri monitor config
- `browser`, `terminal` - Default applications

### For Laptop
Edit `hosts/laptop/variables.nix`:
- Example already includes 2880x1800@60 with 1.2 scaling
- Nvidia Prime bus IDs configured

### Adding New Host

```bash
# Copy template
cp -r hosts/default hosts/newhostname

# Edit configuration
vim hosts/newhostname/variables.nix
vim hosts/newhostname/hardware.nix  # Or generate: nixos-generate-config

# Add to flake.nix
# In nixosConfigurations section:
newhostname = mkHost { hostName = "newhostname"; profileName = "nvidia"; };
```

## Profiles

Choose profile in `flake.nix` based on your GPU:

- `nvidia` - Desktop Nvidia
- `nvidia-laptop` - Laptop with Nvidia Prime (hybrid graphics)
- `amd` - AMD GPU
- `intel` - Intel integrated graphics
- `vm` - Virtual machine (no GPU drivers)

## Troubleshooting

### DankMaterialShell not starting
```bash
# Check if QuickShell is working
dms

# Check logs
journalctl --user -u graphical-session.target

# Fallback launcher
fuzzel
```

### Theme not applying
```bash
# Regenerate theme
matugen image /path/to/wallpaper.jpg

# Check files exist
ls ~/.config/gtk-3.0/dank-colors.css
ls ~/.config/ghostty/config-dankcolors

# Restart apps or re-login
```

### Niri keybindings not working
```bash
# Check Niri config syntax
niri validate

# Edit config
vim ~/.config/niri/config.kdl
```

### Screenshots directory missing
```bash
mkdir -p ~/Pictures/Screenshots
```

## Useful Commands

```bash
# Rebuild system
nh os switch --hostname ritu

# Update flake inputs
nix flake update

# Check flake
nix flake check

# Garbage collection
nh clean all --keep 5

# Test configuration without switching
sudo nixos-rebuild test --flake ~/nixos-config#ritu
```

## Resources

- [Niri Documentation](https://github.com/YaLTeR/niri)
- [DankMaterialShell GitHub](https://github.com/AvengeMedia/DankMaterialShell)
- [QuickShell Documentation](https://quickshell.outfoxxed.me/)
- [Matugen](https://github.com/InioX/matugen)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

## Credits

Based on ZaneyOS by Tyler Kelley, migrated to Niri + DankMaterialShell.

- Original config: [ZaneyOS](https://gitlab.com/Zaney/zaneyos)
- Niri compositor: [YaLTeR](https://github.com/YaLTeR/niri)
- DankMaterialShell: [AvengeMedia](https://github.com/AvengeMedia/DankMaterialShell)
- QuickShell: [outfoxxed](https://github.com/outfoxxed/quickshell)

