{
  lib,
  pkgs,
  ...
}:
{
  users.users.ritu.extraGroups = [ "hermes" ];

  services.hermes-agent = {
    enable = true;
    addToSystemPackages = true;
    workingDirectory = "/var/lib/hermes/workspace";

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.6-luna";
        base_url = "https://chatgpt.com/backend-api/codex";
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
