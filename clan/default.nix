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
      meta = {
        name = "kiesnet";
        domain = "kies";
      };

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

        sshd = {
          module = {
            name = "sshd";
            input = "clan-core";
          };

          roles.server.tags.all = {};
          roles.client.tags.all = {};

          roles.server.settings.certificate.searchDomains = ["kies"];
          roles.client.settings.certificate.searchDomains = ["kies"];
        };

        # internet.roles.default.machines = {
        #   halite.settings.host = "halite";
        #   graphite.settings.host = "graphite";
        #   fluorite.settings.host = "fluorite";
        #   lazurite.settings.host = "lazurite";
        # };

        mycelium.roles.peer.tags.all = {};

        tor = {
          roles.server.tags.nixos = {};
          roles.client.tags.nixos = {};
        };

        yggdrasil.roles.default.tags.all = {};

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

        # ncps = {
        #   roles.server.machines."halite".settings = {
        #     upstream = {
        #       caches = [
        #         "https://cache.nixos.org"
        #         "https://nix-community.cachix.org"
        #         "https://nixpkgs-unfree.cachix.org"
        #         "https://nix-gaming.cachix.org"
        #         "https://cuda-maintainers.cachix.org"
        #         "https://cache.garnix.io"
        #       ];
        #
        #       publicKeys = [
        #         "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        #         "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        #         "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        #         "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        #         "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        #         "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        #       ];
        #     };
        #   };
        #
        #   roles.client.tags.all = {};
        # };
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
