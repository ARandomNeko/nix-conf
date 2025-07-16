{pkgs}:
pkgs.writeShellScriptBin "check_power" ''
  #!/bin/bash

  monitor_name="eDP-1" # Replace with your monitor name
  online_refresh_rate="120" # Replace with your desired online refresh rate
  offline_refresh_rate="60" # Replace with your desired offline refresh rate

  while true; do
    if acpi -a | rg "on-line"; then
      power_state="online"
    else
      power_state="offline"
    fi

    if [ "$power_state" == "online" ]; then
      hyprctl keyword monitor "$monitor_name,2880x1800@$online_refresh_rate,auto,1.2" && notify-send "120 Hz"
    else
      hyprctl keyword monitor "$monitor_name,2880x1880$offline_refresh_rate,auto,1.2" && notify-send "60 Hz"
    fi

    sleep 5 # Check every 5 seconds (adjust as needed)
  done
''
