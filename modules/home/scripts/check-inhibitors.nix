{pkgs}:
pkgs.writeShellScriptBin "check-inhibitors" ''
  #!/bin/bash
  # Check if any process is inhibiting shutdown/sleep
  inhibitors=$(${pkgs.systemd}/bin/loginctl list-inhibitors --no-legend 2>/dev/null)
  
  if [ -n "$inhibitors" ]; then
    # Show notification about active inhibitors
    ${pkgs.libnotify}/bin/notify-send "Active Inhibitors" \
      "Some processes are preventing shutdown/sleep:\n$inhibitors" \
      --urgency=critical \
      --icon=dialog-warning
    echo "blocked"
    exit 1
  else
    echo "clear"
    exit 0
  fi
''

