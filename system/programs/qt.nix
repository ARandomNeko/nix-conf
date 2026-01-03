{lib, ...}: {
  qt = {
    enable = true;
    platformTheme = lib.mkForce "qt6ct";
    style = "adwaita-dark";
  };

  environment.variables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
}
