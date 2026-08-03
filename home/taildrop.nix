{ pkgs, ... }:
{
  # Keep received files beside Downloads without requiring an interactive
  # `tailscale file get` command. Duplicate names are preserved by renaming.
  systemd.user.tmpfiles.rules = [
    "d %h/Taildrop 0755 - - -"
  ];

  systemd.user.services.taildrop-receive = {
    Unit = {
      Description = "Receive Taildrop files into ~/Taildrop";
      StartLimitIntervalSec = 0;
    };

    Service = {
      ExecStart = "${pkgs.tailscale}/bin/tailscale file get --loop --conflict=rename --verbose %h/Taildrop";
      Restart = "always";
      RestartSec = 5;
    };

    Install.WantedBy = [ "default.target" ];
  };
}
