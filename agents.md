# Agent Notes

## Kernel

### Current state (2026-06-15)
- **Configured**: `linuxPackages_testing` (currently Linux 7.1-rc7)
- Uses `lib.mkForce` in `boot.nix` to override nixos-hardware defaults.

### Risks
- Testing kernels may have regressions. If something breaks, switch to `linuxPackages_latest` in `boot.nix` and rebuild.

---

## Lid Close Behavior

### Requirements
- **Always**: lock screen on lid close
- **On battery**: lock *then* suspend
- **On AC power**: lock only (no suspend)

### Implementation
1. **`system/services/laptop.nix`** — logind config:
   - `HandleLidSwitch = "suspend"` → on battery, logind triggers suspend
   - `HandleLidSwitchExternalPower = "lock"` → on AC, logind sends lock signal only
2. **`home/noctalia.nix`** — `lockscreen.enabled = true` for logind lock/unlock integration

### How the flow works
- **Battery + lid close** → logind suspends → Noctalia locks via logind/PrepareForSleep integration before sleep
- **AC + lid close** → logind sends lock signal → Noctalia lockscreen engages (no suspend)

---

## Window Translucency
- Added `window-rule` in niri config: inactive windows get `opacity 0.95`
- niri applies opacity per-surface, so subsurfaces/popups show content behind them
- User can toggle opacity per-window with `toggle-window-rule-opacity` action if desired

## Cheatsheet Shortcut
- `Mod+Shift+Slash` uses niri's built-in `show-hotkey-overlay` action

## Noctalia v5 Integration
- Shell managed via `programs.noctalia` + `systemd.enable` (no manual niri spawn)
- Wallpapers owned by Noctalia (`wallpaper.directory` → repo `wallpapers/`)
- Niri launcher keybinds use `noctalia msg panel-toggle launcher`
- `swaybg` / `swayidle` removed; lock/suspend handled by Noctalia logind integration

## Package Layout
- Language servers, toolchains, and `helix` live in `system/packages/development.nix`
- `home/programs/helix.nix` contains editor config only

## Workflow Rules
- **Small changes**: always commit and push immediately after making them.
- **Large changes/features**: ask the user to create a branch first. These are multi-step changes that may not work right away and need iteration.

## Config Structure Notes
- `boot.nix` uses `lib.mkForce` on kernelPackages to override nixos-hardware module defaults
- Niri is the compositor, Noctalia v5 is the shell/lock screen
