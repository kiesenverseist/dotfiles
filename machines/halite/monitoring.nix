{
  config,
  pkgs,
  ...
}: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "grafana.kiesen.moe";
        root_url = "https://grafana.kiesen.moe";
      };
      security.secret_key = "$__file{${config.clan.core.vars.generators.grafana.files.key.path}}";
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };

  clan.core.vars.generators.grafana = {
    files.key.secret = true;
    files.key.group = "grafana";
    files.key.mode = "0440";

    script = "${pkgs.openssl}/bin/openssl rand -base64 32 > $out/key";
  };

  services.caddy.virtualHosts = let
    inherit (config.services.grafana.settings.server) domain http_addr http_port;
  in {
    ${domain}.extraConfig = ''
      reverse_proxy http://${http_addr}:${toString http_port}
      # import porkbun
    '';
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
  };
}
