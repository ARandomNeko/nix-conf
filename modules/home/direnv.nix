{...}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    
    config = {
      global = {
        hide_env_diff = true;
        warn_timeout = "30s";
      };
    };
  };
  
  # Create a standard .envrc template that can be used in projects
  home.file.".config/direnv/envrc-template".text = ''
    # Use this template for new projects
    # Copy this file to .envrc in your project directory
    # For Nix flakes:
    use flake

    # For legacy nix-shell:
    # use nix

    # For custom shell.nix:
    # use nix shell.nix
  '';
} 