{pkgs}:
pkgs.writeShellScriptBin "niri-refresh-switch" ''
  #!/bin/bash
  # Monitor power state and adjust refresh rate accordingly for battery savings
  
  monitor_name="eDP-1"
  high_refresh="120"
  low_refresh="60"
  
  log_msg() {
    echo "[niri-refresh-switch] $1"
  }
  
  get_power_state() {
    if ${pkgs.acpi}/bin/acpi -a 2>/dev/null | ${pkgs.ripgrep}/bin/rg -q "on-line"; then
      echo "ac"
    else
      echo "battery"
    fi
  }
  
  set_refresh_rate() {
    local rate=$1
    ${pkgs.niri}/bin/niri msg output "$monitor_name" mode --refresh "$rate" 2>/dev/null
    if [ $? -eq 0 ]; then
      log_msg "Set refresh rate to ''${rate}Hz"
      ${pkgs.libnotify}/bin/notify-send -t 2000 "Display" "Refresh rate: ''${rate}Hz" --icon=video-display
    fi
  }
  
  current_state=""
  
  log_msg "Starting refresh rate monitor service"
  
  while true; do
    new_state=$(get_power_state)
    
    if [ "$new_state" != "$current_state" ]; then
      case "$new_state" in
        "ac")
          log_msg "Power connected - switching to high refresh rate"
          set_refresh_rate "$high_refresh"
          ;;
        "battery")
          log_msg "On battery - switching to low refresh rate"
          set_refresh_rate "$low_refresh"
          ;;
      esac
      current_state="$new_state"
    fi
    
    sleep 10
  done
''

