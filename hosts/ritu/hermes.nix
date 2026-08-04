{
  lib,
  pkgs,
  ...
}:
{
  # Keep credentials outside the Nix store. The activation creates this file
  # empty on first deployment; populate it with OPENAI_API_KEY afterwards.
  systemd.tmpfiles.rules = [
    "f /var/lib/hermes/env 0600 hermes hermes -"
    "z /var/lib/hermes/env 0600 hermes hermes - -"
  ];

  users.users.ritu.extraGroups = [ "hermes" ];

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    workingDirectory = "/var/lib/hermes/workspace";

    settings = {
      model = {
        provider = "openai-api";
        default = "gpt-5.6-luna";
        base_url = "https://api.openai.com/v1";
        context_length = 1050000;
      };

      agent = {
        reasoning_effort = "medium";
        max_turns = 60;
        tool_use_enforcement = "auto";
      };

      toolsets = [ "all" ];
      terminal = {
        backend = "local";
        timeout = 180;
      };
      compression = {
        enabled = true;
        threshold = 0.85;
      };
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };

    extraPackages = with pkgs; [
      curl
      fd
      git
      jq
      ripgrep
    ];
  };

  # The upstream native unit is already hardened. Hide user homes as an
  # additional boundary; Hermes only needs its dedicated state/workspace.
  systemd.services.hermes-agent.serviceConfig = {
    EnvironmentFile = "/var/lib/hermes/env";
    ProtectHome = lib.mkForce true;
    PrivateDevices = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    LockPersonality = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
  };
}
