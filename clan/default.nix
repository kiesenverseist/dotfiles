{inputs, ...}: {
  imports = [inputs.clan-core.flakeModules.default];

  clan = {
    specialArgs = {inherit inputs;};

    modules = {
      "@kiesen/restic" = import ./restic.nix;
      "@kiesen/harmonia" = import ./harmonia.nix;
      "@kiesen/prometheus" = import ./prometheus.nix;
    };

    inventory = {
      meta = {name = "kiesnet";};

      machines = {
        lazurite = {
          deploy = {
            buildHost = "kiesen@graphite";
          };
        };
      };

      instances = {
        admin = {
          roles.default.tags.all = {};
          roles.default.settings = {
            allowedKeys = {
              "kiesen" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjmUayWr1sJxYNqGeqtp6fOTT38n/5iGJudDrgf630M";
            };
          };
        };

        # sshd = {
        #   module = {
        #     name = "sshd";
        #     input = "clan-core";
        #   };
        #   roles.server.tags.all = {};
        #   roles.client.tags.all = {};
        # };

        internet.roles.default.machines = {
          halite.settings.host = "halite";
          graphite.settings.host = "graphite";
          fluorite.settings.host = "fluorite";
          lazurite.settings.host = "lazurite";
        };

        kiesen-user = {
          module = {
            name = "users";
            input = "clan-core";
          };

          roles.default.tags.all = {};
          roles.default.settings = {
            user = "kiesen";

            groups = [
              "wheel"
              "networkmanager"
              "video"
              "input"
              "libvirtd"
              "qemu-libvirtd"
              "dialout"
            ];

            share = true;
          };
        };

        restic = {
          module.name = "@kiesen/restic";
          module.input = "self";
          roles.default.tags.all = {};
        };

        harmonia = {
          module.name = "@kiesen/harmonia";
          module.input = "self";
          roles.server.machines = {
            graphite = {};
            halite = {};
          };
          roles.client.tags.all = {};
        };

        syncthing = {
          roles.peer.machines = {
            fluorite = {};
          };
          roles.peer.settings.folders = {
            documents = {
              path = "~/Documents/";
            };
          };
        };

        prometheus = {
          module.name = "@kiesen/prometheus";
          module.input = "self";
          roles.exporter.machines = {
            graphite = {};
            halite = {};
            lazurite = {};
          };
          roles.scraper.machines.halite = {};
        };
      };
    };
  };

  # perSystem = {inputs', ...}: {
  #   devenv.shells.default = {
  #     packages = [
  #       inputs'.clan-core.packages.clan-cli
  #     ];
  #   };
  # };
}
