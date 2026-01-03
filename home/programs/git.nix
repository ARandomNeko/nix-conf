{...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "ARandomNeko";
        email = "rituparanreddy2006@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "hx";
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };
  };

  # Delta for better diffs
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
