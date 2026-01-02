{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "ARandomNeko";
  gitEmail = "rituparanreddy2006@gmail.com";

  # Niri/Monitor Settings
  extraMonitorSettings = ''
    output "eDP-1" {
        mode "2880x1800@60"
        scale 1.2
        variable-refresh-rate
    }
  '';

  # Program Options
  browser = "zen"; # Set Default Browser
  terminal = "ghostty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # For Nvidia Prime support
  intelID= "PCI:65:0:0";
  nvidiaID = "PCI:0:2:0";
}

