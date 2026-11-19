{ lib, pkgs, ... }:
let
  python = pkgs.python3.withPackages (ps: [ ps.dbus-python ]);
  helper = pkgs.writeShellScript "keepassxc-session" ''
    export PATH=${lib.makeBinPath [ pkgs.keepassxc pkgs.libsecret pkgs.systemd ]}
    exec ${python}/bin/python3 ${./keepassxc-session.py} "$@"
  '';
  # Keep the GUI's browser and sharing settings in their existing writable files.
  preferences = pkgs.writeShellScript "keepassxc-session-preferences" ''
    set -eu
    umask 077
    configDir="''${XDG_CONFIG_HOME:-$HOME/.config}/keepassxc"
    stateDir="''${XDG_STATE_HOME:-$HOME/.local/state}/keepassxc"
    ${pkgs.coreutils}/bin/mkdir -p "$configDir" "$stateDir"
    for key in ShowTrayIcon MinimizeToTray MinimizeOnClose; do
      ${pkgs.crudini}/bin/crudini --set "$configDir/keepassxc.ini" GUI "$key" true
    done
    ${pkgs.crudini}/bin/crudini --set "$stateDir/keepassxc.ini" Security QuickUnlock false
  '';
in
{
  home-manager.users.ritu = {
    systemd.user.services.keepassxc-login = {
      Unit = {
        Description = "Open KeePassXC from the GNOME login keyring";
        After = [ "graphical-session-pre.target" "gnome-keyring-daemon.service" ];
        PartOf = [ "graphical-session.target" ];
        ConditionPathExists = "%h/Passwords.kdbx";
      };
      Service = {
        ExecStartPre = preferences;
        ExecStart = "${helper} launch";
        UMask = "0077";
        LimitCORE = 0;
        NoNewPrivileges = true;
        StandardOutput = "null";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    programs.noctalia.settings.hooks = {
      session_locked = "${pkgs.systemd}/bin/busctl --user --auto-start=no call org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow lockAllDatabases";
      session_unlocked = "${helper} unlock";
    };

    home.file = {
      ".local/bin/keepassxc-unlock".source = pkgs.writeShellScript "keepassxc-unlock" ''
        exec ${helper} unlock
      '';
      ".local/bin/keepassxc-keyring-setup".source = pkgs.writeShellScript "keepassxc-keyring-setup" ''
        exec ${helper} setup
      '';
    };
  };
}
