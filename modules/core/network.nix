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

  # Make NetworkManager start asynchronously and don't block boot
  systemd.services.NetworkManager = {
    # Don't require network-online.target - start in parallel
    wants = [ "dbus.service" ];
    after = [ "dbus.service" ];
    # Remove any blocking dependencies
    before = [ ];
    # Add timeout to prevent hanging
    serviceConfig = {
      TimeoutStartSec = "30s";
      TimeoutStopSec = "10s";
    };
  };

  # Ensure network-online.target doesn't block anything
  systemd.network.wait-online.enable = false;

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}

