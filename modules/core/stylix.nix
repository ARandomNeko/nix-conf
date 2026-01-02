{pkgs, ...}: {
  # Styling Options
  stylix = {
    enable = true;
    image = ../../wallpapers/adrien-olichon-RCAhiGJsUUE-unsplash.jpg;
    base16Scheme = {
      base00 = "100F0F"; # bg - background
      base01 = "1C1B1A"; # bg-2 - lighter background
      base02 = "343331"; # ui-2 - selection background
      base03 = "575653"; # tx-3 - comments, invisibles
      base04 = "878580"; # tx-2 - dark foreground
      base05 = "CECDC3"; # tx - default foreground
      base06 = "CECDC3"; # light foreground
      base07 = "CECDC3"; # lightest foreground
      base08 = "D14D41"; # re - red (variables, markup, deletion)
      base09 = "DA702C"; # or - orange (integers, boolean, constants)
      base0A = "D0A215"; # ye - yellow (classes, markup bold, search text bg)
      base0B = "879A39"; # gr - green (strings, inherited class, markup code)
      base0C = "3AA99F"; # cy - cyan (support, regular expressions, escape chars)
      base0D = "4385BE"; # bl - blue (functions, methods, attribute IDs, headings)
      base0E = "8B7EC8"; # pu - purple (keywords, storage, selector, markup italic)
      base0F = "CE5D97"; # ma - magenta (deprecated, opening/closing embedded language tags)

      name = "flexoki";
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
        package = pkgs.nerd-fonts.jetbrains-mono;
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

