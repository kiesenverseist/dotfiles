{inputs, ...}: {
  flake-file.inputs.tangled = {
    url = "git+https://tangled.org/tangled.org/core?ref=refs/tags/v1.16.1-alpha";
    inputs.nixpkgs.follows = "nixpkgs";
    # inputs.flake-compat.follows = "flake-compat";
    # Disable useless monorepo inputs
    # inputs.actor-typeahead-src.follows = "";
    # inputs.fenix.follows = "";
    # inputs.htmx-src.follows = "";
    # inputs.htmx-ws-src.follows = "";
    # inputs.ibm-plex-mono-src.follows = "";
    # inputs.inter-fonts-src.follows = "";
    # inputs.lucide-src.follows = "";
    # inputs.mermaid-src.follows = "";
  };

  clan.inventory.instances.import-spindle = {
    module.name = "importer";
    roles.default.machines.halite = {};
    roles.default.extraModules = [
      inputs.tangled.nixosModules.spindle 
      ({pkgs, ... }: {
        services.tangled = {
          spindle = {
            enable = true;
            server = {
              owner = "did:plc:en6yraip4v5hl4aenyxpy4xo";
              hostname = "spindle.kiesen.dev";
              listenAddr = "0.0.0.0:5556";
            };
          };
        }; 

        systemd.tmpfiles.settings.spindle-nixos-image = {
          # as this failed to build, i manually built and copied it from another computer
          # "/var/lib/spindle/images/nixos"."L+" = {
          #   argument = toString inputs.tangled.packages.${pkgs.stdenv.hostPlatform.system}.spindle-nixos-image;
          # }; 
          "/var/lib/spindle/images/alpine"."L+" = {
            argument = toString inputs.tangled.packages.${pkgs.stdenv.hostPlatform.system}.spindle-alpine-image;
          }; 
        };

        virtualisation.docker.enable = true;
        # virtualisation.podman = {
        #   enable = true;
        #   dockerSocket.enable = true;
        # };
      })
    ];
  };

  clan.inventory.instances.import-knot = {
    module.name = "importer";
    roles.default.machines.lazurite = {};
    roles.default.extraModules = [
      inputs.tangled.nixosModules.knot 
      ({ ... }: {
        services.tangled = {
          knot = {
            enable = true;
            stateDir = "/var/lib/tangled/knot";
            repo.scanPath = "/var/lib/tangled/knot/repos";
            server = {
              owner = "did:plc:en6yraip4v5hl4aenyxpy4xo";
              hostname = "knot.kiesen.dev";
              listenAddr = "0.0.0.0:5555";
            };
          };
        }; 
      })
    ];
  };

}
