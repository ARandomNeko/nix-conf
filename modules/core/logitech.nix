{ pkgs, config, lib, ... }: {
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # Solaar/GUI support

  # Logid service for gestures and advanced button mapping
  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Configuration for logiops
  environment.etc."logid.cfg".text = ''
    devices: (
      {
        name: "MX Master 2S";
        smartshift: { on: true; threshold: 20; };
        hires_scroll: { enabled: true; };

        buttons: (
          {
            cid: 0xc4; # Thumb button
            action = {
              type: "Gestures";
              gestures: (
                {
                  direction: "Up";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_PAGEUP"]; # Mod+Page_Up (focus-workspace-up in niri)
                  };
                },
                {
                  direction: "Down";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_PAGEDOWN"]; # Mod+Page_Down (focus-workspace-down in niri)
                  };
                },
                {
                  direction: "Left";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_H"]; # Mod+H (focus-column-left in niri)
                  };
                },
                {
                  direction: "Right";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_L"]; # Mod+L (focus-column-right in niri)
                  };
                },
                {
                  direction: "None";
                  mode: "OnRelease";
                  action = {
                    type: "Keypress";
                    keys: ["KEY_LEFTMETA", "KEY_SPACE"]; # Mod+Space (Toggle spotlight in dms)
                  };
                }
              );
            };
          }
        );
      }
    );
  '';
}
