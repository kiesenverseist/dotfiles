{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    # nixpkgs-stable.url = github:nixos/nixpkgs;

    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nixgl.url = "github:guibou/nixGL";

  };

  outputs = {self, nixos-hardware, ...}@inputs:
  let 
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      inherit system;

      config = {
          allowUnfree = true;
      };

      # TODO: remove
      config.permittedInsecurePackages = [
        "electron-24.8.6"
      ];
    
      overlays = [inputs.nixgl.overlay];
    };

    nix-alien-pkg = inputs.nix-alien.packages.${system};

  in {
    nixosConfigurations = {
      "halite" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};

        modules = [
          ./hosts/halite
        ];
      };
      "graphite" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};

        modules = [
          ./hosts/graphite
        ];
      };
      "live" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        inherit system;
        modules = [
          (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./hosts/live
        ];
      };
    };

    homeConfigurations = {
        "kiesen@halite" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home-halite.nix ];
          extraSpecialArgs = {
            nix-gaming = inputs.nix-gaming;
            nix-alien = nix-alien-pkg.nix-alien;
          };
        };
        "kiesen@graphite" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home/home-graphite.nix ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
          extraSpecialArgs = {
            nix-gaming = inputs.nix-gaming;
            nix-alien = nix-alien-pkg.nix-alien;
          };
        };
        "kiesen@kiesen-eos-laptop" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/home-laptop.nix ];
        };
        "ibrahim.fuad@au-lap-0102.saberastronautics.net" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/work-laptop.nix ];
        };

    };
  };
}
