{ pkgs, ... }: {
  networking = {
    # Use Cloudflare DNS as the global fallback; VPN links can still provide
    # per-link DNS through systemd-resolved.
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];

    # Modern firewall
    nftables.enable = true;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  services = {
    resolved.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  # Don't block boot on NetworkManager declaring the network online.
  systemd.services.NetworkManager-wait-online.enable = false;
}
