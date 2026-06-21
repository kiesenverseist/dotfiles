{inputs, ...}: {
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  clan.inventory.instances.import-nix-index = {
    module.name = "importer";
    roles.default.tags.nixos = {};
    roles.default.extraModules = [
      inputs.nix-index-database.nixosModules.default
      { programs.nix-index-database.comma.enable = true; }
    ];
  };
}
