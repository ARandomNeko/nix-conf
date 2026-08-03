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
- **Optimized Shell:** Nushell with a `starship` prompt, FZF integration, and custom aliases.
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

## 🌏 Remote development: NJ → Hyderabad

The `ritu` profile builds the Hyderabad server named `mnemosyne`; the `laptop`
profile builds the New Jersey client named `eschaton`. They connect through
Tailscale, so SSH does not require a public IP, router port forwarding, or a
public port 22.

On the Hyderabad machine, rebuild locally and enroll it in the tailnet:

```bash
sudo nixos-rebuild switch --flake .#ritu
sudo tailscale up --ssh --hostname=mnemosyne
```

On the New Jersey laptop:

```bash
sudo nixos-rebuild switch --flake .#laptop
sudo tailscale up --hostname=eschaton
ssh mnemosyne
```

The same `mnemosyne` entry works with editor Remote SSH extensions. For a
terminal that survives network changes, use `mosh mnemosyne`. Every interactive
terminal automatically creates or attaches to the persistent tmux session
named `dev`; detach safely with `Ctrl-a d`.

Taildrop files sent to either Linux machine are received automatically in
`~/Taildrop`, beside `~/Downloads`. The receiver starts with the user session;
on `mnemosyne`, user lingering keeps it running after boot without a login.
Duplicate filenames are renamed instead of overwritten. The declarative
`--operator=ritu` setting lets the user service empty Tailscale's inbox without
root access.

### Tmux cheatsheet

Tmux uses `Ctrl-a` as its prefix: press `Ctrl-a`, release it, then press the key
listed below. The full field manual is always available inside tmux with
`Ctrl-a ?` and closes with `q`.

| Key | Action |
| :--- | :--- |
| `Ctrl-a d` | Detach while leaving every process running |
| `Ctrl-a ?` | Open the complete cheatsheet in a popup |
| `Ctrl-a \|` / `Ctrl-a -` | Split right / below in the current directory |
| `Ctrl-a h/j/k/l` | Move between panes |
| `Ctrl-a H/J/K/L` | Resize panes |
| `Ctrl-a c` | Create a window in the current directory |
| `Ctrl-a n/p` | Move to the next / previous window |
| `Ctrl-a s` | Browse sessions, windows, and panes |
| `Ctrl-a g/e/b` | Open lazygit / Helix / btop in a popup |
| `Ctrl-a F` | Fuzzy-find tmux objects and commands |
| `Ctrl-a Space` | Select and copy visible URLs, paths, hashes, or numbers |
| `Ctrl-a [` | Enter Vim-style copy mode; use `v`, then `y` |
| `Ctrl-a C-s` / `Ctrl-a C-r` | Save / restore a session snapshot |
| `Ctrl-a r` | Reload the configuration |

Continuum snapshots all sessions every 10 minutes and restores them when tmux
starts after a reboot. The status bar and popup colors are regenerated from the
active Noctalia wallpaper palette.

### Remote desktop

The server starts a Niri session automatically after boot and runs Sunshine in
that session. The laptop profile installs Moonlight. Sunshine's stream ports
are open only on the Tailscale interface; its administration page remains
local-only.

After rebuilding both profiles, open a temporary tunnel from the laptop:

```bash
ssh -L 47990:localhost:47990 mnemosyne
```

Keep that terminal open, visit `https://localhost:47990`, and create the
Sunshine administrator account. Launch Moonlight, manually add the computer
`mnemosyne`, select **Desktop**, and enter Moonlight's pairing PIN in the
tunneled Sunshine page. The tunnel is only needed for administration and
pairing, not for normal desktop streaming.

The auto-login is intentional: Sunshine captures an active graphical session,
so without it remote desktop would remain unavailable after an unattended
reboot. The server still needs firmware/BIOS **Restore on AC Power Loss** set to
**Power On** if it must recover automatically from a complete power outage.

Tailscale SSH access is governed by the tailnet access policy. Both machines
must be signed into the same tailnet, and that policy must allow your identity
to SSH as `ritu`. Cloudflare WARP is disabled on these two profiles because its
routes overlap Tailscale's address space on this setup.

## 🛠️ Credits & Inspiration
This configuration is built upon the giants:
- **[zaneyOS](https://gitlab.com/Zaney/zaneyos):** For the initial structure and base modules.
- **[kaku:](https://github.com/linuxmobile/kaku)** For deep inspiration and config patterns.
- **[Noctalia Devs](https://github.com/noctalia-dev):** For the incredible shell framework.
