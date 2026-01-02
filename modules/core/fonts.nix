{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      material-icons
      material-symbols
      fira-code
      nerd-fonts.space-mono
    ];
  };
}

