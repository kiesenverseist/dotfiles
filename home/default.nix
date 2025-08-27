{inputs, ...}: {
  imports = [inputs.home-manager.flakeModules.home-manager];

  flake = {
    homeConfigurations = let
      conf = module:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
            config = {allowUnfree = true;};
            overlays = [inputs.nixgl.overlay];
          };
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
      };
  };
}
