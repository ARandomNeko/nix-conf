{ pkgs, ... }:
{
  # Private connectivity for the Hyderabad server. The first login still
  # requires `sudo tailscale up --ssh --hostname=hyd` from a local terminal.
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [
      "--hostname=hyd"
      "--ssh"
    ];
  };

  # Keep the regular OpenSSH daemon available as a fallback, but expose it
  # only inside the tailnet. Tailscale SSH normally handles connections to
  # the Tailscale address before they reach this daemon.
  services.openssh = {
    openFirewall = false;
    settings = {
      AllowUsers = [ "ritu" ];
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PermitEmptyPasswords = false;
      PubkeyAuthentication = true;
      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = true;
      GatewayPorts = "no";
      UseDns = false;
      MaxAuthTries = 3;
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
    };
  };

  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [ 22 ];
    allowedUDPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];
  };

  # Remote shells and user services should survive disconnects and reboots.
  users.users.ritu.linger = true;
  environment.systemPackages = with pkgs; [
    mosh
    tmux
  ];

  # A remote server must not disappear because a desktop power action put it
  # to sleep. Shutdown and reboot remain available.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };
}
