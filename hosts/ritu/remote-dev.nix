{ lib, pkgs, ... }:
let
  # Sunshine loads NVENC through dlopen. LD_LIBRARY_PATH is intentionally
  # ignored for capability-wrapped executables, so add the live NVIDIA driver
  # directory to the binary's RUNPATH instead.
  sunshineNvidia =
    pkgs.runCommand "${pkgs.sunshine.name}-nvidia"
      {
        nativeBuildInputs = [ pkgs.addDriverRunpath ];
        meta.mainProgram = "sunshine";
      }
      ''
        cp -a ${pkgs.sunshine} $out
        chmod u+w $out/bin/sunshine
        addDriverRunpath $out/bin/sunshine
      '';
in
{
  # Private connectivity for the Hyderabad server. The first login still
  # requires `sudo tailscale up --ssh --hostname=mnemosyne` locally.
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [
      "--hostname=mnemosyne"
      "--ssh"
    ];
  };

  # WARP currently installs routes covering Tailscale's 100.64.0.0/10 space.
  # Do not let two overlay VPNs compete on an unattended server.
  services.cloudflare-warp.enable = lib.mkForce false;

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
    # SSH plus Sunshine's HTTPS, HTTP, and RTSP endpoints. The Sunshine
    # administration UI (47990) stays closed and is reached through SSH.
    allowedTCPPorts = [
      22
      47984
      47989
      48010
    ];
    allowedUDPPorts = [
      47998
      47999
      48000
      48002
      48010
    ];
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

  # Stream the existing Niri session to Moonlight. Sunshine is a user service
  # tied to graphical-session.target, so greetd must start that session after
  # an unattended reboot rather than waiting for a local login.
  services.sunshine = {
    enable = true;
    package = sunshineNvidia;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = false;
  };

  services.greetd.settings.initial_session = {
    command = "${pkgs.niri}/bin/niri-session";
    user = "ritu";
  };

  # A remote server must not disappear because a desktop power action put it
  # to sleep. Shutdown and reboot remain available.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };
}
