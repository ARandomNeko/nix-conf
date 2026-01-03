{
  lib,
  pkgs,
  ...
}: let
  toKDL = import ./_to-KDL.nix {inherit lib pkgs;};
  settings = import ./_settings.nix {inherit lib pkgs;};
  binds = import ./_binds.nix {inherit pkgs;};
  rules = import ./_rules.nix;

  finalConfig = toKDL.generate "niri-config.kdl" (settings // {binds = binds;} // rules);
in {
  environment.sessionVariables = {
    NIRI_CONFIG = "$HOME/.config/niri/config.kdl";
  };

  users.users.ritu.packages = with pkgs; [
    niri
    xwayland-satellite  # XWayland support for X11 apps (Steam, etc.)
  ];

  xdg.configFile."niri/config.kdl".text = builtins.readFile finalConfig;
}
