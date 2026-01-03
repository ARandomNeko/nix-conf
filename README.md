# ❄️ nix-conf

My personal NixOS configuration, built around the **Niri** scrollable tiling compositor and **Noctalia** shell. This setup is designed to be aesthetic, functional, and highly optimized for both my ASUS G14 laptop and my NVIDIA-powered desktop.

---

## 🖥️ System Overview

| Host | Description | Hardware Focus |
| :--- | :--- | :--- |
| `laptop` | **ASUS ROG Zephyrus G14 (2024)** | AMD CPU/GPU, Power management, Lid behavior |
| `ritu` | **Main Workstation** | AMD CPU, NVIDIA GPU, Performance focused |
| `default` | **Template** | Generic x86_64 NixOS configuration |

## ✨ Key Features

- **Window Management:** [Niri](https://github.com/sodiboo/niri-flake) - A unique scrollable-tiling Wayland compositor that feels more natural than traditional grids.
- **Desktop Shell:** [Noctalia](https://github.com/noctalia-dev/noctalia-shell) - A complete shell with a status bar, notifications, and integrated system controls.
- **Dynamic Theming:** [Matugen](https://github.com/InioS/matugen) - Material You color generation that pulls palettes from your wallpaper.
- **Optimized Shell:** `fish` with `starship` prompt and custom aliases.
- **Modern CLI Tools:** `yazi` for files, `helix` for code, `btop` for monitoring.

## 📦 Core Applications

- **Editor:** Helix (hx)
- **Terminal:** Ghostty
- **File Manager:** Yazi (TUI) / Nautilus (GUI)
- **Browser:** Zen Browser (Flatpak)
- **Media:** MPV, IMV, Zathura (PDF)
- **Social:** Vesktop (Discord)

## 🚀 Installation

> [!CAUTION]
> This configuration is tailored to my specific hardware. If you are not me, **do not** run this blindly. You will likely need to adjust `hardware.nix` and `variables.nix`.

### 1. Prerequisites
- **NixOS** installed on your machine.
- **Experimental features** enabled (`nix-command` and `flakes`).

### 2. Clone the Repository
```bash
git clone https://github.com/ARandomNeko/nix-conf.git ~/nix-conf
cd ~/nix-conf
```

### 3. Setup Hardware Configuration
Each host directory expects a `hardware.nix`. If you're setting up a new host, generate it first:
```bash
nixos-generate-config --show-hardware-config > ./hosts/<your-host-name>/hardware.nix
```

### 4. Deploy Configuration
I use `nh` for a better management experience.

**Install/Switch:**
```bash
nh os switch . --hostname <laptop|ritu|default>
```

**Manual (No `nh`):**
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## 🛠️ Credits & Inspiration
This configuration is built upon the giants:
- **[zaneyOS](https://gitlab.com/Zaney/zaneyos):** For the initial structure and base modules.
- **kaku:** For deep inspiration and config patterns.
- **[Noctalia Devs](https://github.com/noctalia-dev):** For the incredible shell framework.

---
*This shit is maintained by [Rituparan Reddy](https://github.com/ARandomNeko)*
