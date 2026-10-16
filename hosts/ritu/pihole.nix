{ config, pkgs, ... }:
{
  # FTL 6.7.1 leaves an unused loop counter that fails with GCC 16's -Werror.
  # Keep the fix scoped to this version so future updates use upstream code.
  nixpkgs.overlays = [
    (_final: prev: {
      pihole-ftl =
        if prev.pihole-ftl.version == "6.7.1" then
          prev.pihole-ftl.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              ../../system/packages/pihole-ftl-unused-hosts-counter.patch
            ];
          })
        else
          prev.pihole-ftl;
    })
  ];

  # Pi-hole handles policy; Unbound caches and validates public DNS answers
  # while forwarding exclusively over authenticated TLS to Cloudflare.
  services.unbound = {
    enable = true;
    resolveLocalQueries = false;
    checkconf = true;
    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1/32 allow" ];
        tls-cert-bundle = config.security.pki.caBundle;
        hide-identity = true;
        hide-version = true;
        prefetch = true;
        prefetch-key = true;
        verbosity = 0;
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          # A failed TLS upstream must not fall back to plaintext recursion.
          forward-first = false;
          forward-addr = [
            "1.1.1.1@853#one.one.one.one"
            "1.0.0.1@853#one.one.one.one"
          ];
        }
      ];
    };
  };

  # Native Pi-hole v6 service. Keep the resolver off loopback so it can
  # coexist with systemd-resolved's local stub on port 53.
  services.pihole-ftl = {
    enable = true;
    privacyLevel = 0;

    # Firewall access is scoped to the physical LAN and tailnet below.
    openFirewallDNS = false;
    openFirewallDHCP = false;
    openFirewallWebserver = false;

    queryLogDeleter = {
      enable = true;
      age = 1;
      interval = "daily";
    };

    lists = [
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.plus.txt";
        description = "HaGeZi Multi Pro++ ads and tracking";
      }
      {
        url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.medium.txt";
        description = "HaGeZi Threat Intelligence Feeds Medium";
      }
    ];

    settings = {
      dns = {
        upstreams = [ "127.0.0.1#5335" ];
        dnssec = true;
        # Keep dashboard troubleshooting history without a second text log.
        queryLogging = false;
        domainNeeded = true;
        expandHosts = true;

        # NONE lets the dnsmasq directives below use bind-dynamic for both
        # interfaces. This survives Ethernet or Tailscale disappearing and
        # returning without turning the host into an open resolver.
        listeningMode = "NONE";
        revServers = [
          "true,192.168.29.0/24,192.168.29.1,lan"
        ];
        hosts = [
          "192.168.29.38 mnemosyne.lan"
          "100.105.150.62 mnemosyne.tailnet"
        ];
      };

      # Retain one day of query history while the stronger lists settle in.
      database.maxDBdays = 1;

      misc.dnsmasq_lines = [
        "bind-dynamic"
        "interface=enp42s0"
        "interface=tailscale0"
      ];

      # The dashboard is intentionally unauthenticated but reachable only on
      # loopback. Administration therefore requires the existing SSH access.
      webserver = {
        acl = "+127.0.0.1,+[::1]";
        api = {
          allow_destructive = false;
          # Required for the setup unit's short-lived API authentication.
          cli_pw = true;
        };
      };
    };
  };

  systemd.services.pihole-ftl = {
    after = [ "unbound.service" ];
    wants = [ "unbound.service" ];
  };

  services.pihole-web = {
    enable = true;
    ports = [ "127.0.0.1:8080" ];
  };

  # Route this host's ordinary DNS through its own Pi-hole. The route-only
  # root domain takes precedence over DNS learned from router DHCP, while
  # Tailscale's more-specific MagicDNS domains continue to use Tailscale.
  services.resolved.settings.Resolve = {
    DNS = [ "127.0.0.1" ];
    Domains = [ "~." ];
    # Do not silently bypass filtering if FTL is unavailable.
    FallbackDNS = [ ];
  };

  networking.firewall = {
    # Limit Ethernet clients by source address. Interface-wide port rules
    # would also admit globally routed IPv6 traffic arriving on enp42s0.
    extraInputRules = ''
      iifname "enp42s0" ip saddr 192.168.29.0/24 tcp dport 53 accept comment "Pi-hole DNS from LAN"
      iifname "enp42s0" ip saddr 192.168.29.0/24 udp dport 53 accept comment "Pi-hole DNS from LAN"
    '';

    # Tailscale authenticates and encrypts this interface; tailnet ACLs remain
    # the authority for which enrolled devices may reach the resolver.
    interfaces.tailscale0 = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  # On a new installation the upstream setup unit can race FTL reopening the
  # freshly-created gravity database. A retry sees the database in place and
  # loads the declarative lists normally.
  systemd.services.pihole-ftl-setup = {
    # Staying active makes a later declarative list change restart this unit
    # during nixos-rebuild instead of leaving the new list unapplied.
    wantedBy = [ "multi-user.target" ];
    # The upstream setup script only adds lists. Retire our former default
    # explicitly, without touching any lists added manually in the dashboard.
    preStart = ''
      if [ -s ${config.services.pihole-ftl.settings.files.gravity} ]; then
        ${pkgs.pihole-ftl}/bin/pihole-FTL sqlite3 ${config.services.pihole-ftl.settings.files.gravity} \
          "UPDATE adlist SET enabled = 0 WHERE address = 'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts';"
      fi
    '';
    serviceConfig = {
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };

  # Refresh gravity without tying blocklist freshness to system rebuilds.
  systemd.services.pihole-gravity = {
    description = "Update Pi-hole gravity database";
    after = [
      "network-online.target"
      "pihole-ftl.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "pihole-ftl.service" ];
    serviceConfig = {
      Type = "oneshot";
      User = "pihole";
      Group = "pihole";
      ExecStart = "${pkgs.pihole}/bin/pihole -g";
      Nice = 10;
      IOSchedulingClass = "idle";
    };
  };

  systemd.timers.pihole-gravity = {
    description = "Daily Pi-hole gravity update";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:30:00";
      RandomizedDelaySec = "30m";
      Persistent = true;
      Unit = "pihole-gravity.service";
    };
  };

  environment.systemPackages = [ pkgs.bind.dnsutils ];
}
