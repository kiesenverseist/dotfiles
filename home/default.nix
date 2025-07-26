{
  inputs,
  pkgs,
}: let
  conf = module:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        module
        inputs.stylix.homeModules.stylix
        ./modules
      ];
    };
in
  builtins.mapAttrs (_: module: conf module) {
    "kiesen@halite" = ./home-halite.nix;
    "kiesen@graphite" = ./home-graphite.nix;
    "kiesen@kiesen-eos-laptop" = ./home-laptop.nix;
    "kiesen@fluorite" = ./home-fluorite.nix;
  }
