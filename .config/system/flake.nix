{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs-stable.url = github:nixos/nixpkgs;

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = github:hyprwm/Hyprland?submodules=1;
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # hypridle.url = "github:hyprwm/hypridle";
    # hyprlock = {
    #   url = "github:hyprwm/hyprlock";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow/tags/v0.36.0";
      inputs.hyprland.follows = "hyprland";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nixgl.url = "github:guibou/nixGL";
    
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {self, ...}@inputs:
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

    # pkgs-master = import inputs.nixpkgs-master {
    #   inherit system;
    #   config = {
    #       allowUnfree = true;
    #   };
    # };

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
          inputs.foundryvtt.nixosModules.foundryvtt
          inputs.lix-module.nixosModules.default
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

    homeConfigurations = let
      config = inputs.home-manager.lib.homeManagerConfiguration;
    in {
      "kiesen@halite" = config {
        inherit pkgs;
        modules = [ ./home/home-halite.nix ];

        extraSpecialArgs = {
          nix-gaming = inputs.nix-gaming;
          nix-alien = nix-alien-pkg.nix-alien;
        };
      };
      "kiesen@graphite" = config {
        inherit pkgs;
        modules = [ ./home/home-graphite.nix ];

        extraSpecialArgs = {
          inherit inputs;
          nix-alien = nix-alien-pkg.nix-alien;
        };
      };
      "kiesen@kiesen-eos-laptop" = config {
        inherit pkgs;
        modules = [ ./home/home-laptop.nix ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
      "ibrahim.fuad@au-lap-0618.saberastronautics.net" = config {
        inherit pkgs;
        modules = [ ./home/work-laptop.nix ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };
      "ibrahim.fuad@graphite" = config {
        inherit pkgs;
        modules = [ ./home/work-graphite.nix ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };

    packages.${system} = {
      vm = inputs.nixos-generators.nixosGenerate {
        inherit system pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vm
          ({lib, ...}: {system.build.qcow = lib.mkDefault {
            diskSize = lib.mkForce "auto";
            additionalSpace = "10G";
          };})
        ];
        format = "qcow";
      };
    };
  };
}
