_: {
  programs.niri.enable = true;

  services = {
    displayManager.autoLogin.enable = false;

    displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/ritu";
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };

    greetd.settings = {
      initial_session = {
        user = "ritu";
        command = "niri-session";
      };
    };
  };
}
