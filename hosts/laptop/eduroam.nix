{ ... }:
{
  # Supply NetworkManager's SecretAgent interface and keep the Rutgers
  # password in the user's login keyring.
  programs.nm-applet.enable = true;

  # Rutgers' SecureW2 profile as published for Linux on 2026-09-01.
  # The password is owned by the user's NetworkManager secret agent, so it is
  # neither written here nor copied into the Nix store.
  networking.networkmanager.ensureProfiles.profiles.eduroam = {
    connection = {
      id = "eduroam";
      type = "wifi";
      autoconnect = true;
      autoconnect-priority = 20;
      permissions = "user:ritu:;";
    };

    wifi = {
      mode = "infrastructure";
      security = "wifi-security";
      ssid = "eduroam";
    };

    wifi-security = {
      auth-alg = "open";
      group = "ccmp;";
      key-mgmt = "wpa-eap";
      pairwise = "ccmp;";
      pmf = 3;
    };

    "802-1x" = {
      ca-cert = "${./rutgers-eduroam-ca.pem}";
      domain-suffix-match = "ise.ruw.rutgers.edu";
      eap = "ttls;";
      identity = "rrg97@rutgers.edu";
      password-flags = 1;
      phase2-auth = "pap";
    };

    ipv4.method = "auto";
    ipv6 = {
      addr-gen-mode = "stable-privacy";
      method = "auto";
    };
    proxy = { };
  };
}
