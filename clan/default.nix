{inputs, ...}: {
  imports = [inputs.clan-core.flakeModules.default];

  clan = {
    specialArgs = {inherit inputs;};

    modules = {
      "@kiesen/restic" = import ./restic.nix;
      "@kiesen/harmonia" = import ./harmonia.nix;
      "@kiesen/prometheus" = import ./prometheus.nix;
      "@kiesen/proxmox" = import ./proxmox.nix;
    };

    inventory = {
      meta = {name = "kiesnet";};

      machines = {
        lazurite = {
          deploy = {
            buildHost = "graphite";
          };
        };
      };

      instances = {
        admin = {
          roles.default.tags.all = {};
          roles.default.settings = {
            allowedKeys = {
              "kiesen-fluorite" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjmUayWr1sJxYNqGeqtp6fOTT38n/5iGJudDrgf630M";
              "kiesen-graphite" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILB44rGxgd27wPLkuUrHXlnrpEhqVQX92k1F3TVNYIWQ";
            };
            # certificateSearchDomains = ["ladon-minnow.ts.net"];
          };
        };

        # sshd = {
        #   module = {
        #     name = "sshd";
        #     input = "clan-core";
        #   };
        #   roles.server.tags.all = {};
        #   roles.client.tags.all = {};
        #
        #   # roles.server.settings.certificate.searchDomains = ["ladon-minnow.ts.net"];
        #   roles.client.settings.certificate.searchDomains = ["ladon-minnow.ts.net"];
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
              "video"
              "input"
              "libvirtd"
              "qemu-libvirtd"
              "dialout"
              "docker"
              "minecraft"
              "adbusers"
            ];

            share = true;
          };
        };

        talux-user = {
          module = {
            name = "users";
            input = "clan-core";
          };

          roles.default.machines = {
            fluorite = {};
            graphite = {};
          };

          roles.default.settings = {
            user = "talux";

            groups = [
              "video"
              "input"
              "libvirtd"
              "qemu-libvirtd"
              "docker"
            ];

            share = true;
          };

          roles.default.extraModules = [
            ({pkgs, ...}: {
              imports = [inputs.home-manager.nixosModules.default];
              home-manager = {
                extraSpecialArgs = {inherit inputs;};
                users.talux.imports = [../home/talux.nix];
                backupCommand = "${pkgs.trash-cli}/bin/trash";
              };
            })
          ];
        };

        media-user = {
          module = {
            name = "users";
            input = "clan-core";
          };

          roles.default.machines.halite = {};
          roles.default.settings = {
            user = "media";
            groups = ["media"];
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

        proxmox = {
          module.name = "@kiesen/proxmox";
          module.input = "self";
          roles.default.machines = {
            # use the tailscale network as the proxmox backbone
            # graphite.settings.ipAddress = "100.119.227.45";
            halite.settings.ipAddress = "100.120.252.116";
          };
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
