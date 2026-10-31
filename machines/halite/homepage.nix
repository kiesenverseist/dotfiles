{config, ...}: {
  services.caddy = {
    virtualHosts = {
      "www.kiesen.moe".extraConfig = ''
        reverse_proxy http://localhost:${toString config.services.homepage-dashboard.listenPort}
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
            "Immich" = {
              icon = "immich.png";
              href = "https://immich.kiesen.moe";
            };
          }
          {
            "Bookorbit" = {
              icon = "bookorbit.png";
              href = "https://bookorbit.kiesen.moe";
            };
          }
          {
            "Seerr" = {
              icon = "seerr.png";
              href = "https://seerr.kiesen.moe";
            };
          }
        ];
      }
      {
        "Home" = [
          {
            "Home assistant" = {
              icon = "home-assistant.png";
              href = "https://hass.kiesen.moe";
            };
          }
          {
            "zigbee2mqtt" = {
              icon = "zigbee2mqtt.png";
              href = "https://z2m.kiesen.moe";
            };
          }
          {
            "slzb-mr2" = {
              href = "http://slzb-mr2.local";
            };
          }
          {
            "Open Thread Border Router" = {
              href = "https://otbr.kiesen.moe";
            };
          }
          {
            "Music assistant" = {
              icon = "music-assistant.png";
              href = "https://mass.kiesen.moe";
            };
          }
          {
            "Homebox" = {
              icon = "homebox.png";
              href = "https://homebox.kiesen.moe";
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
