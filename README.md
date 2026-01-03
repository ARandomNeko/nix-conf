System wide NixOS flake using niri and noctalia
Desktop Shell Framework

quickshell - Core desktop shell toolkit (QtQuick/QML based)
noctalia-shell - Complete desktop shell built on quickshell

Components Provided by Noctalia (via quickshell)

Status bar - Modular bar with workspace indicators, system monitors
Notifications - Built-in notification system with history panel (replaces mako)
Lock screen - PAM authentication with time display (replaces swaylock)
Application launcher - Stylized launcher with favorites and recent apps (replaces fuzzel)
Side panel - Quick access with media controls, weather, power profiles
Settings panel - Comprehensive configuration interface
System tray - Application tray with menu support
Widgets - Desktop widgets for various system info
OSD overlays - Volume, brightness overlays

Core Applications

Code editing: Helix
File explorer (TUI): Yazi
Browser: Zen (flatpak, installed declaratively)
Terminal: ghostty 
Shell: fish (with starship prompt)

System Integration

Screenshot: grim + slurp (noctalia has gpu-screen-recorder integration)
Screen recording: gpu-screen-recorder (integrated in noctalia)
Color picker: hyprpicker
Clipboard manager: cliphist (noctalia has built-in integration)
Wallpaper: swaybg / noctalia's background manager
Idle management: swayidle (or noctalia's idle detection)

Media & Viewers

Image viewer: imv
Video player: mpv (MPRIS integrated with noctalia)
PDF viewer: zathura
Music player: spotify (flatpak) / ncmpcpp + mpd
System monitor: btop
Media controls: playerctl (integrated via noctalia's MPRIS)

Theming & Appearance

Dynamic theming: matugen (Material You color generation, noctalia integration)
Audio visualizer: cava (noctalia integration)
Night light: wlsunset (noctalia integration)
GTK theme: Via matugen + noctalia theming system
Qt theme: Via matugen + noctalia theming system
Fonts: Nerd Fonts (JetBrainsMono, Inter, Roboto - noctalia uses these)

System Services

Authentication agent: polkit-kde-agent
Audio: pipewire (wireplumber) with noctalia's Pipewire integration
Power management: power-profiles-daemon (noctalia integration)
Brightness control: brightnessctl (noctalia integration)
Battery monitoring: UPower (noctalia integration)
Bluetooth: BlueZ (noctalia integration)

Additional Tools

File manager (GUI): thunar / nautilus
Archive manager: ark / file-roller
Discord: vesktop (flatpak)
Calendar: evolution-data-server (for noctalia calendar widget)

This flake supports multiple hosts the laptop host is currently an asus g14 (2024) all optimizations must be done accordingly. the ritu host is a desktop with an nvidia gpu. 