{pkgs, ...}: {
  # Styling Options
  stylix = {
    enable = true;
    image = ../../wallpapers/mountainscapedark.jpg;
    base16Scheme = {
      base00 = "1c1b1a";
      base01 = "282726";
      base02 = "6f6e69";
      base03 = "9f9d96";
      base04 = "205EA6";
      base05 = "FFFCF0";
      base06 = "f2f0e5";
      base07 = "cecdc3";
      base08 = "CE5D97";
      base09 = "5e409d";
      base0A = "879A39";
      base0B = "a0af54";
      base0C = "66a0c8";
      base0D = "205EA6";
      base0E = "b45bcf";
      base0F = "00f769";
    };
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
