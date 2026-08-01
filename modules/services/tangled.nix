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
  clan.inventory.instances.import-homebox = {
    module.name = "importer";
    roles.default.machines.halite = {};
    roles.default.extraModules = [
      inputs.tangled.nixosModules.knot 
      inputs.tangled.nixosModules.spindle 
      ({
        # config,
        # lib,
        # pkgs,
        ...
      }: let
      in {
        services.tangled = {
          knot = {
            enable = true;
            stateDir = "/var/lib/tangled/knot";
            server = {
              owner = "did:plc:en6yraip4v5hl4aenyxpy4xo";
              hostname = "knot.kiesen.dev";
              listenAddr = "0.0.0.0:5555";
            };
          };
          spindle = {
            enable = true;
            server = {
              owner = "did:plc:en6yraip4v5hl4aenyxpy4xo";
              hostname = "spindle.kiesen.dev";
              listenAddr = "0.0.0.0:5556";
            };
          };
        }; 
      })
    ];
  };
}
