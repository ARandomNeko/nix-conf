# Agent Notes

## Kernel 6.19 Upgrade

### Current state (2026-02-07)
- **Running**: 6.18.8 (via `linuxPackages_6_18` with `lib.mkForce`)
- **kernel.org mainline**: 6.19-rc8 (released 2026-02-01)
- **kernel.org stable**: 6.18.8 (released 2026-01-30) — this is the latest *stable* release
- **nixpkgs unstable `linux_testing`**: 6.19-rc7 (modDirVersion: 6.19.0-rc7)
- **nixpkgs unstable `linux_latest`**: 6.18.8

### Timeline estimate
- 6.19-rc8 released Feb 1. Stable 6.19 release is imminent — likely Feb 9-16 based on typical cadence.
- Once 6.19 goes stable, nixpkgs will get `linuxPackages_6_19` within days.

### Decision
- Using `linuxPackages_testing` (6.19-rc7) for now. This is the standard nixpkgs package for the mainline RC.
- `boot.nix` uses `lib.mkForce` to override nixos-hardware defaults — keep that.
- **TODO**: Once `linuxPackages_6_19` lands in nixpkgs, switch from `linuxPackages_testing` to `linuxPackages_6_19` for a stable kernel.

### Risks
- RC kernels may have regressions. 6.19-rc8 exists but nixpkgs only has rc7.
- If something breaks, revert to `linuxPackages_6_18` in boot.nix and rebuild.

---

## Lid Close Behavior

### Requirements
- **Always**: lock screen on lid close
- **On battery**: lock *then* suspend
- **On AC power**: lock only (no suspend)

### Implementation (already done in working tree)
1. **`system/services/laptop.nix`** — logind config:
   - `lidSwitch = "suspend"` → on battery, logind triggers suspend
   - `lidSwitchExternalPower = "lock"` → on AC, logind sends lock signal only
2. **`home/niri.nix`** — swayidle spawned at startup:
   - `before-sleep` → calls `noctalia-shell ipc call lockScreen lock` (locks before suspend)
   - `lock` → calls `noctalia-shell ipc call lockScreen lock` (locks on logind lock signal)

### How the flow works
- **Battery + lid close** → logind sends suspend → swayidle `before-sleep` fires → screen locks → system suspends
- **AC + lid close** → logind sends lock signal → swayidle `lock` fires → screen locks (no suspend)

---

## Window Translucency
- Added `window-rule` in niri config: inactive windows get `opacity 0.95`
- niri applies opacity per-surface, so subsurfaces/popups show content behind them
- User can toggle opacity per-window with `toggle-window-rule-opacity` action if desired

## Cheatsheet Shortcut Fix
- `Mod+Shift+Slash` was calling `noctalia-shell ipc call cheatsheet toggle` — **this IPC endpoint does not exist**
- Noctalia's actual IPC endpoints: `launcher`, `controlCenter`, `settings`, `calendar`, `sessionMenu`, `systemMonitor`, `volume`, `brightness`, `lockScreen`, etc. No "cheatsheet".
- Fixed to use niri's built-in `show-hotkey-overlay` action instead, which shows all configured keybinds natively.

## Noctalia Double-Start Fix
- noctalia-shell was started twice: once via `spawn-at-startup` in niri config, once via systemd user service in `noctalia.nix`
- Removed the `spawn-at-startup` line; kept the systemd service (handles restarts, proper session ordering)

## Config Structure Notes
- `boot.nix` uses `lib.mkForce` on kernelPackages to override nixos-hardware module defaults
- Niri is the compositor, noctalia-shell is the shell/lock screen
- swayidle handles sleep/lock event bridging between logind and noctalia
