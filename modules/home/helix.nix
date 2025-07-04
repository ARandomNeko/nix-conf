{
  inputs,
  config,
  lib,
  ...
}: {
programs.helix = {
  enable = true;
  settings = {
    theme = lib.mkForce"flexoki_dark_transparent";
    editor.cursor-shape = {
      normal = "block";
      insert = "bar";
      select = "underline";
    };
  };
  languages.language = [{
    name = "nix";
    auto-format = true;
  }];
  themes = {
    flexoki_dark_transparent= {
      "inherits" = "flexoki_dark";
      "ui.background" = { };
    };
  };
};
}
