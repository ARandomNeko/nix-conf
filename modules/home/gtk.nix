{ pkgs, username, ... }:

{
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # Remove manual theme configuration to let Stylix handle it
    # gtk3.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
    # gtk4.extraConfig = {
    #   gtk-application-prefer-dark-theme = 1;
    # };
  };
  
  # Matugen theme integration (using stylix-preferred method)
  stylix.targets.gtk.extraCss = ''
    @import url("file:///home/${username}/.config/gtk-3.0/dank-colors.css");
    @import url("file:///home/${username}/.config/gtk-4.0/dank-colors.css");
  '';
}
