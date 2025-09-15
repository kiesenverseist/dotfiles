{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    (inputs.otbr + "/nixos/modules/services/home-automation/openthread-border-router.nix")
  ];

  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
      frontend.themes = "!include_dir_merge_named themes";
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = ["::1"];
      };
      homeassistant = {
        media_dirs = {
          media = "/var/media";
        };
      };
    };
    # config = null;
    lovelaceConfig = null;
    extraComponents = [
      "analytics"
      "default_config"
      "esphome"
      "shopping_list"
      "wled"
      "met"
      "radio_browser"
      "google_translate"
      "isal"
      "cloud"
      "network"
      "config"
      "mobile_app"
      "tuya"
      "nanoleaf"
      "aussie_broadband"
      "ipp"
      "discord"
      "epson"
      "assist_pipeline"
      "assist_satellite"
      "homeassistant"
      "homeassistant_hardware"
      "islamic_prayer_times"
      "jellyfin"
      "mqtt"
      "music_assistant"
      "prusalink"
      "samsungtv"
      "smlight"
      "tailscale"
      "syncthing"
      "transport_nsw"
      "unifi"
      "zeroconf"
      "thread"
      "ollama"
      "roborock"
      "immich"
      "daikin"
      "http"
    ];
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      bubble-card
      zigbee2mqtt-networkmap
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      samsungtv-smart
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.zigbee2mqtt_2;
    settings = {
      homeassistant.enabled = config.services.home-assistant.enable;
      permit_join = true;
      serial = {
        port = "tcp://192.168.1.35:7638";
        baudrate = 115200;
        adapter = "zstack";
        disable_led = false;
      };
      advanced.transmit_power = 20;
      frontend = {
        package = "zigbee2mqtt-windfront";
        enabled = true;
        port = 8099;
      };
      mqtt = {
        server = "mqtt://localhost:1883";
        user = "z2m";
        password = "!${config.clan.core.vars.generators.mosquitto-user-z2m.files."secret.yaml".path} password";
      };
    };
  };

  clan.core.vars.generators = let
    mkPasswordGenerator = user: {
      files.password = {
        secret = true;
        # deploy = false;
      };
      files.password-hash = {
        secret = true;
        # owner = "mosquitto";
        # mode = "0400";
      };

      runtimeInputs = [
        pkgs.mosquitto
        pkgs.xkcdpass
      ];

      script = ''
        xkcdpass --numwords 4 --delimiter - --count 1 | tr -d "\n" > "$out"/password
        mosquitto_passwd -c -b "$out"/password-hash ${user} $(cat "$out"/password)
      '';
    };
  in {
    mosquitto-user-garage-ac = mkPasswordGenerator "garage-ac";
    mosquitto-user-hass = mkPasswordGenerator "hass";
    mosquitto-user-z2m = {
      files.password = {
        secret = true;
        # deploy = false;
      };
      files.password-hash = {
        secret = true;
        # owner = "mosquitto";
        # mode = "0400";
      };
      files."secret.yaml" = {
        secret = true;
        owner = "zigbee2mqtt";
        mode = "0400";
        restartUnits = ["zigbee2mqtt.service"];
      };

      runtimeInputs = [
        pkgs.xkcdpass
        pkgs.mosquitto
      ];

      script = ''
        xkcdpass --numwords 4 --delimiter - --count 1 | tr -d "\n" > "$out"/password
        mosquitto_passwd -c -b "$out"/password-hash z2m $(cat "$out"/password)
        cat << EOF > $out/secret.yaml
          password: $(cat $out/password)
        EOF
      '';
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          garage-ac = {
            acl = ["readwrite #"];
            # hashedPasswordFile = config.clan.core.vars.generators.mosquitto-user-garage-ac.files.password-hash.path;
            passwordFile = config.clan.core.vars.generators.mosquitto-user-garage-ac.files.password.path;
          };
          hass = {
            acl = ["readwrite #"];
            # hashedPasswordFile = config.clan.core.vars.generators.mosquitto-user-hass.files.password-hash.path;
            passwordFile = config.clan.core.vars.generators.mosquitto-user-hass.files.password.path;
          };
          z2m = {
            acl = ["readwrite #"];
            passwordFile = config.clan.core.vars.generators.mosquitto-user-z2m.files.password.path;
          };
        };
      }
    ];
  };

  services.music-assistant = {
    enable = true;
    providers = [
      "ytmusic"
      "hass"
      "snapcast"
    ];
  };

  # services.snapserver = {
  #   enable = true;
  # };

  services.matter-server = {
    enable = true;
  };

  services.openthread-border-router = {
    enable = true;
    logLevel = "debug";
    package = inputs.otbr.legacyPackages.${pkgs.system}.openthread-border-router;
    backboneInterface = "br0";
    radio.url = "spinel+hdlc+uart:///tmp/ttyOTBR?uart-baudrate=460800";
    rest.listenAddress = "0.0.0.0";
    web.listenAddress = "0.0.0.0";
  };

  systemd.services.otbr-network = {
    description = "otbr network to tty";
    requires = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["otbr-agent.service"];
    before = ["otbr-agent.service"];
    path = [pkgs.socat];
    script = ''
      socat -d pty,raw,echo=0,link=/tmp/ttyOTBR,ignoreeof "tcp:192.168.1.35:6638"
    '';
  };

  services.caddy.virtualHosts = let
    inherit (config.services) zigbee2mqtt openthread-border-router;
  in {
    "z2m.kiesen.moe".extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString zigbee2mqtt.settings.frontend.port}
      import porkbun
    '';
    "otbr.kiesen.moe".extraConfig = ''
      reverse_proxy http://localhost:${builtins.toString openthread-border-router.web.listenPort}
      import porkbun
    '';
    "hass.kiesen.moe".extraConfig = ''
      reverse_proxy http://[::1]:8123
      import porkbun
    '';
    "mass.kiesen.moe".extraConfig = ''
      reverse_proxy http://localhost:8095
      import porkbun
    '';
  };
}
