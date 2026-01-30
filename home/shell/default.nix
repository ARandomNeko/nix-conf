{pkgs, ...}: {
  imports = [
    ./ghostty.nix
    ./nushell.nix
  ];

  # Starship prompt
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      format = "$all";
      add_newline = true;

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
      };

      git_status = {
        style = "bold yellow";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      nodejs = {
        symbol = " ";
      };

      rust = {
        symbol = " ";
      };

      python = {
        symbol = " ";
      };
    };
  };

  # Direnv for dev environments
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  # Fuzzy finder
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Carapace completions for nushell
  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
