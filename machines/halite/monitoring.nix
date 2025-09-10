{config, ...}: {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.kiesen.moe";
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

  services.caddy.virtualHosts = let
    inherit (config.services.grafana.settings.server) domain http_addr http_port;
  in {
    ${domain}.extraConfig = ''
      reverse_proxy http://${http_addr}:${builtins.toString http_port}
      import porkbun
    '';
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
  };
}
