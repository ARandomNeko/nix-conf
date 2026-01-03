{pkgs, ...}: {
  imports = [
    ./ghostty.nix
  ];

  # Fish shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Better ls
      alias ls='eza --icons'
      alias ll='eza -la --icons'
      alias lt='eza --tree --icons'

      # Better cat
      alias cat='bat'

      # Git shortcuts
      alias g='git'
      alias gs='git status'
      alias ga='git add'
      alias gc='git commit'
      alias gp='git push'
      alias gl='git log --oneline --graph'

      # Nix shortcuts
      alias nrs='sudo nixos-rebuild switch --flake .'
      alias nrt='sudo nixos-rebuild test --flake .'
      alias nfu='nix flake update'
    '';
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
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
    nix-direnv.enable = true;
  };

  # Fuzzy finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}

