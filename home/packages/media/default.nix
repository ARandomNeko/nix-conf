{pkgs, ...}: {
  users.users.ritu.packages = with pkgs; [
    alsa-utils
    easyeffects
  ];
}
