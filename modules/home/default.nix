{inputs, ...}: {
  imports = [inputs.home-manager.flakeModules.home-manager];

  flake = {
    homeConfigurations = let
      conf = module:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
            config = {allowUnfree = true;};
            # overlays = [inputs.nixgl.overlay];
          };
          extraSpecialArgs = {inherit inputs;};
          modules = [module ./_modules];
        };
    in
      builtins.mapAttrs (_: module: conf module) {
        "kiesen@halite" = ./_homes/home-halite.nix;
        "kiesen@graphite" = ./_homes/home-graphite.nix;
        "kiesen@fluorite" = ./_homes/home-fluorite.nix;
      };
  };
}
