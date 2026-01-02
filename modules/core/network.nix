{ pkgs, host, options, ... }:
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    # Disable wait-online to prevent boot delays
    networkmanager.unmanaged = [ "interface-name:lo" ];
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  # Faster boot by not waiting for network to be fully online
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}

