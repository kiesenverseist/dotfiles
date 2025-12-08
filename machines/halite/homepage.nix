{config, ...}: {
  services.caddy = {
    virtualHosts = {
      "www.kiesen.moe".extraConfig = ''
        reverse_proxy http://localhost:${builtins.toString config.services.homepage-dashboard.listenPort}
        # import porkbun
      '';
    };
  };

  # TODO: figure out how to do secrets
  
  services.homepage-dashboard = {
    enable = true;
    listenPort = 8083;
    allowedHosts = "www.kiesen.moe";
    widgets = [
      {
        search = {
          provider = "duckduckgo";
          target = "_blank";
        };
      }
    ];
    services = [
      {
        "Media" = [
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              href = "https://jellyfin.kiesen.moe";
            };
          }
          {
            "Jellyseerr" = {
              icon = "jellyseerr.png";
              href = "https://jellyseerr.kiesen.moe";
            };
          }
        ];
      }
      {
        "Home" = [
          {
            "Home assistant" = {
              icon = "hass.png";
              href = "https://hass.kiesen.moe";
            };
          }
          {
            "zigbee2mqtt" = {
              href = "https://z2m.kiesen.moe";
            };
          }
          {
            "Open Thread Border Router" = {
              href = "https://otbr.kiesen.moe";
            };
          }
          {
            "Music assistant" = {
              href = "https://mass.kiesen.moe";
            };
          }
        ];
      }
      {
        "System" = [
          {
            "Caddy" = {
              icon = "caddy.png";
              widget = {
                type = "caddy";
                url = "http://localhost:2019";
              };
            };
          }
          {
            "Grafana" = {
              icon = "grafana.png";
              href = "https://grafana.kiesen.moe";
            };
          }
        ];
      }
    ];
  };
}
