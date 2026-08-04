{
  config,
  pkgs,
  ...
}:
let
  repository = "/home/ritu/nix-conf";
  runAsRitu = "${pkgs.util-linux}/bin/runuser --user ritu -- env HOME=/home/ritu XDG_CACHE_HOME=/home/ritu/.cache";

  updateNix = pkgs.writeShellApplication {
    name = "nix-conf-weekly-update";
    runtimeInputs = with pkgs; [
      coreutils
      git
      nix
      util-linux
    ];
    text = ''
      repository=${repository}
      activated=0
      lock_updated=0

      restore_failed_update() {
        status=$?
        if [ "$status" -ne 0 ] && [ "$lock_updated" -eq 1 ] && [ "$activated" -eq 0 ]; then
          echo "Update failed before activation; restoring the previous flake.lock" >&2
          ${runAsRitu} git -C "$repository" restore --source=HEAD -- flake.lock
        fi
        exit "$status"
      }
      trap restore_failed_update EXIT

      exec 9>"$repository/.git/weekly-update.lock"
      if ! flock --nonblock 9; then
        echo "Another weekly update is already running; exiting"
        exit 0
      fi

      if [ -n "$(${runAsRitu} git -C "$repository" status --porcelain)" ]; then
        echo "Refusing to update a dirty worktree: $repository" >&2
        exit 1
      fi

      ${runAsRitu} git -C "$repository" pull --ff-only origin main
      ${runAsRitu} nix flake update --flake "$repository"
      lock_updated=1

      # Validate every real machine before changing the running desktop.
      ${runAsRitu} nix build --no-link \
        "$repository#nixosConfigurations.ritu.config.system.build.toplevel" \
        "$repository#nixosConfigurations.laptop.config.system.build.toplevel"

      ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch \
        --flake "$repository#ritu"
      activated=1

      if ! ${runAsRitu} git -C "$repository" diff --quiet -- flake.lock; then
        ${runAsRitu} git -C "$repository" add flake.lock
        ${runAsRitu} git -C "$repository" commit -m "chore: weekly flake update"
      fi

      # Keep main as the source of truth for the generation now running.
      ${runAsRitu} git -C "$repository" push origin main
    '';
  };
in
{
  systemd.services.nix-conf-weekly-update = {
    description = "Update, validate, and activate all Nix flake inputs";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${updateNix}/bin/nix-conf-weekly-update";
      Nice = 10;
      IOSchedulingClass = "idle";
      TimeoutStartSec = "4h";
    };
  };

  systemd.timers.nix-conf-weekly-update = {
    description = "Run the guarded NixOS update every Sunday";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 04:00:00";
      Persistent = true;
      RandomizedDelaySec = "1h";
      Unit = "nix-conf-weekly-update.service";
    };
  };

  systemd.services.flatpak-weekly-update = {
    description = "Update system Flatpaks";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update --system --assumeyes --noninteractive";
      Nice = 10;
      IOSchedulingClass = "idle";
      TimeoutStartSec = "2h";
    };
  };

  systemd.timers.flatpak-weekly-update = {
    description = "Update Flatpaks every Sunday";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 06:00:00";
      Persistent = true;
      RandomizedDelaySec = "1h";
      Unit = "flatpak-weekly-update.service";
    };
  };
}
