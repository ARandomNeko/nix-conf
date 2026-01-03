{pkgs, ...}: {
  networking = {
    # Use Cloudflare DNS
    nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];

    # Modern firewall
    nftables.enable = true;

    networkmanager = {
      enable = true;
      dns = "default"; # Use nameservers above
      wifi.powersave = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  # Don't wait for network startup (faster boot)
  systemd.services.NetworkManager-wait-online.serviceConfig.ExecStart = [
    ""
    "${pkgs.networkmanager}/bin/nm-online -q"
  ];
}

