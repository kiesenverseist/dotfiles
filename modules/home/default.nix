{inputs, ...}: {
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    evergarden = {
      url = "https://codeberg.org/evergarden/nix/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

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
