# nix-conf

My personal NixOS configuration for an NVIDIA desktop and an ASUS ROG Zephyrus
G14 laptop. Both use the Niri Wayland compositor, Noctalia shell, and Home Manager
for user configuration.

This repository is shared as a reference for others building a similar setup.
Hardware, user accounts, paths, and network services are specific to my machines;
adapt those settings before applying a profile to your own system.

## Desktop and tools

- **Niri + Noctalia:** scrollable tiling, an application launcher, notifications,
  a lock screen, and wallpaper-based colors through Matugen.
- **Ghostty + Nushell:** Starship prompt, Carapace completions, Zoxide, FZF, and
  Direnv with nix-direnv.
- **Development:** Helix and Zed, language servers and toolchains, Git with Delta,
  and tmux with session snapshots and themed popups.
- **Everyday applications:** Zen Browser through Flatpak, Yazi and Nautilus,
  MPV, IMV, Zathura, and Steam.
- **Laptop support:** NVIDIA PRIME offload, ASUS utilities, TLP power management,
  zram, and LibrePods integration with Noctalia. Closing the lid suspends on
  battery and locks without suspending on AC power.

Dependencies come from `nixos-unstable` and the other inputs in
[flake.nix](flake.nix); [flake.lock](flake.lock) pins their revisions. Home Manager
is integrated into the NixOS configurations, so a system rebuild also applies
the user configuration.

## Host profiles

| Flake target | System hostname | Purpose |
| --- | --- | --- |
| `ritu` | `mnemosyne` | NVIDIA desktop, remote development server, and LAN/tailnet DNS |
| `laptop` | `eschaton` | ASUS ROG Zephyrus G14 with AMD/NVIDIA hybrid graphics and remote development clients |

These are the two exported `nixosConfigurations`, both for `x86_64-linux`.
`hosts/default/` contains template files but is not an exported build target.
Use the flake target, rather than the system hostname, in rebuild commands.

## Repository layout

```text
flake.nix              Flake inputs and outputs
flake.lock             Pinned dependency revisions
hosts/default.nix      Host definitions and module wiring
hosts/ritu/            Desktop hardware, packages, and services
hosts/laptop/          Laptop hardware, packages, and services
hosts/default/         Unwired template files
system/                Shared NixOS modules and package definitions
home/                  Home Manager modules, desktop settings, and shell config
home/templates/        Custom wallpaper-based theme templates
wallpapers/            Wallpaper collection used by Noctalia
```

## Adapting the configuration

Start with an existing NixOS installation, Git, and the `nix-command` and `flakes`
experimental features enabled. The included boot configuration assumes UEFI with
systemd-boot.

Fork the repository if you plan to maintain your own version, then clone your
fork. To browse this configuration locally:

```bash
git clone https://github.com/ARandomNeko/nix-conf.git
cd nix-conf
```

Choose a profile to adapt. The examples below use `laptop`; use `ritu` for the
desktop profile. Generate a hardware configuration on the machine you intend to
configure and review it before replacing the selected profile's `hardware.nix`:

```bash
nixos-generate-config --show-hardware-config > /tmp/hardware-configuration.nix
```

Review these settings before the first rebuild:

- **Hardware and boot:** replace the selected host's `hardware.nix`, check
  [boot settings](system/core/boot.nix), and adjust the GPU drivers, PRIME bus IDs,
  hostname, and hardware module in [hosts/default.nix](hosts/default.nix). The
  desktop also declares a `/data` filesystem in
  [hosts/ritu/default.nix](hosts/ritu/default.nix).
- **User account:** change the `ritu` account in
  [system/core/default.nix](system/core/default.nix) and
  [home/default.nix](home/default.nix), including the home directory. Update
  references in any host services you retain. Set your own Git identity in
  [home/programs/git.nix](home/programs/git.nix).
- **Desktop and paths:** adjust display settings and keybindings in
  [home/niri.nix](home/niri.nix), wallpaper and avatar paths in
  [home/noctalia.nix](home/noctalia.nix), and `NH_FLAKE` in
  [system/nix/nh.nix](system/nix/nh.nix).
- **Host services:** review the imports in the selected host's `default.nix`.
  Adapt or remove the remote access, Pi-hole, Hermes, and automatic update modules
  as appropriate. The laptop's [eduroam profile](hosts/laptop/eduroam.nix) contains
  an institution-specific identity and certificate configuration.
- **Access policy:** review [system/core/security.nix](system/core/security.nix),
  including passwordless sudo for the `wheel` group, and the desktop's automatic
  graphical login in [hosts/ritu/remote-dev.nix](hosts/ritu/remote-dev.nix).

The `variables.nix` files are not currently imported by the active configurations;
edit the modules above directly. Keep passwords, tokens, and private keys out of
tracked Nix files; provision credentials locally for the services you enable.

Build the adapted profile before activating it:

```bash
nix build '.#nixosConfigurations.laptop.config.system.build.toplevel' --no-link
sudo nixos-rebuild switch --flake '.#laptop'
```

Once `nh` is available, the equivalent switch command is:

```bash
nh os switch . --hostname laptop
```

To add a separate host, create its directory under `hosts/` and wire a new
`nixosSystem` entry into [hosts/default.nix](hosts/default.nix).

## Host-specific services

The service modules document the deployment details and are useful starting
points if you want similar functionality:

- **Remote development:** [desktop](hosts/ritu/remote-dev.nix) and
  [laptop](hosts/laptop/remote-dev.nix) modules configure Tailscale, SSH/Mosh, and
  Sunshine/Moonlight. The desktop starts a graphical session automatically for
  streaming; its Sunshine administration port is accessed through an SSH tunnel.
  SSH uses OpenSSH keys over Tailscale; the desktop authorizes the laptop's
  public key declaratively and also reads `~/.ssh/authorized_keys`. Tailscale
  enrollment and tailnet access policies are configured separately.
- **DNS:** [hosts/ritu/pihole.nix](hosts/ritu/pihole.nix) configures native Pi-hole
  services for the LAN and tailnet, with a loopback-only dashboard. Public DNS
  goes through local Unbound on port 5335 to Cloudflare over authenticated TLS,
  with DNSSEC validation and no plaintext recursion fallback. HaGeZi Pro++ and
  TIF Medium refresh daily; the previous StevenBlack list is disabled during
  setup, while manually added lists are preserved. Query history is kept for
  one day and DNS text logging is disabled. Interface names, addresses, public
  keys, and DNS policy need adapting to your network.
- **Hermes:** [hosts/ritu/hermes.nix](hosts/ritu/hermes.nix) runs the agent under a
  dedicated service account with its own workspace. Authentication is provisioned
  locally after deployment.
- **Updates:** [hosts/ritu/auto-update.nix](hosts/ritu/auto-update.nix) runs weekly
  desktop updates from a clean checkout, builds both profiles, switches the
  desktop, and commits and pushes lockfile changes to `main`. Flatpaks update on
  a separate timer. Review the repository path and Git remote before retaining
  this automation.

Both profiles also use [Taildrop](home/taildrop.nix) to receive files in
`~/Taildrop`. Tmux uses `Ctrl-a` as its prefix; `Ctrl-a ?` opens the
[full cheatsheet](home/programs/tmux-cheatsheet.md). In Nushell, `tm` creates or
attaches to the persistent `dev` session.

## Credits

- [zaneyOS](https://gitlab.com/Zaney/zaneyos) for the initial structure and base modules.
- [kaku](https://github.com/linuxmobile/kaku) for configuration patterns and inspiration.
- [Niri](https://github.com/YaLTeR/niri) and [niri-flake](https://github.com/sodiboo/niri-flake).
- [Noctalia](https://github.com/noctalia-dev/noctalia-shell) for the desktop shell and theming.
