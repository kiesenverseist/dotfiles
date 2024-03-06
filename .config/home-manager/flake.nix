{
  description = "Home Manager configuration of kiesen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = { nixpkgs, home-manager, nix-gaming, nix-alien, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree=true;
        config.permittedInsecurePackages = [
          "electron-24.8.6"
        ];
        overlays = [nixgl.overlay];
      };
      nix-alien-pkg = nix-alien.packages.${system};
    in {
      homeConfigurations = {
        "kiesen@halite" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit nix-gaming;
            nix-alien = nix-alien-pkg.nix-alien;
          };
        };
        "kiesen@graphite" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home-graphite.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            inherit nix-gaming;
            nix-alien = nix-alien-pkg.nix-alien;
          };
        };
        "kiesen@kiesen-eos-laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home-laptop.nix ];
        };
        "ibrahim.fuad@au-lap-0102.saberastronautics.net" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./work-laptop.nix ];
        };
      };
    };
}
