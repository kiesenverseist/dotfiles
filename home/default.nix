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
in {
  "kiesen@halite" = conf ./home-halite.nix;
  "kiesen@graphite" = conf ./home-graphite.nix;
  "kiesen@kiesen-eos-laptop" = conf ./home-laptop.nix;
  "kiesen@fluorite" = conf ./home-fluorite.nix;
  "ibrahim.fuad@au-lap-0618.saberastronautics.net" = conf ./work-laptop.nix;
  "ibrahim.fuad@graphite" = conf ./work-graphite.nix;
}
