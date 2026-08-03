{ lib, pkgs, ... }:
{
  # Private connectivity from the New Jersey laptop to the Hyderabad server.
  # The first login requires `sudo tailscale up --hostname=eschaton`.
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [ "--hostname=eschaton" ];
  };

  # Avoid routing Tailscale traffic into Cloudflare WARP.
  services.cloudflare-warp.enable = lib.mkForce false;

  environment.systemPackages = [ pkgs.mosh ];

  # Client for the Sunshine desktop stream hosted by `mnemosyne`.
  programs.moonlight-qt.enable = true;

  # The laptop initiates SSH connections but does not need to accept them.
  services.openssh.enable = lib.mkForce false;

  # This is also consumed by editors that use the OpenSSH config, including
  # VS Code/Cursor Remote SSH. Tailscale MagicDNS resolves `mnemosyne`.
  home-manager.users.ritu.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        ServerAliveInterval = 30;
        ServerAliveCountMax = 6;
        HashKnownHosts = true;
      };

      mnemosyne = {
        HostName = "mnemosyne";
        User = "ritu";
        Port = 22;
        Compression = true;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "10m";
      };
    };
  };
}
