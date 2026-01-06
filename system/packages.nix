{ pkgs, ... }:
{
  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    wget
    curl
    unzip
    zip
    ripgrep
    fd
    eza
    bat
    fzf
    jq

    # System tools
    htop
    btop
    procps
    matugen
    fastfetch
    pciutils
    usbutils
    lshw
    stress

    # System packages
    obsidian
    prismlauncher
    steam
    komikku

    # Development
    gcc
    gnumake

    # AI tools
    gemini-cli-bin
    code-cursor-fhs

    # Fonts
    nerd-fonts.jetbrains-mono
    inter
    roboto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "Inter" ];
      serif = [ "Roboto" ];
    };
  };
}
