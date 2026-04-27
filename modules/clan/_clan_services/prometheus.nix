{
  _class = "clan.service";
  manifest.name = "prometheus";

  roles.exporter = {
    perInstance = {...}: {
      nixosModule = {config, ...}: {
        services.prometheus = {
          exporters = {
            node = {
              enable = true;
              enabledCollectors = ["systemd"];
            };
          };
        };

        networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
          config.services.prometheus.exporters.node.port
        ];
      };
    };
  };

  roles.scraper = {
    perInstance = {roles, ...}: {
      nixosModule = {config, ...}: let
        exporters = builtins.attrNames roles.exporter.machines;
        default_port = builtins.toString config.services.prometheus.exporters.node.port;
      in {
        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "10s";
          # if settings are needed look into lib.attrsToList
          scrapeConfigs =
            builtins.map (hostname: {
              job_name = hostname;
              static_configs = [{targets = ["${hostname}:${default_port}"];}];
            })
            exporters;
        };
      };
    };
  };
}
