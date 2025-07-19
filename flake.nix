{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-alien.url = "github:thiagokokada/nix-alien";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl-fix = {
      url = "github:johanneshorner/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    hyprhook = {
      url = "github:hyprhook/hyprhook";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/plasma-5";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    colmena.url = "github:zhaofengli/colmena";
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      overlays = [inputs.nixgl.overlay];
    };
  in {
    nixosConfigurations = import ./hosts {inherit inputs system;};

    homeConfigurations = import ./home {inherit inputs pkgs;};

    packages.${system} = {
      vm = inputs.nixos-generators.nixosGenerate {
        inherit system pkgs;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/vm
          ({lib, ...}: {
            system.build.qcow = lib.mkDefault {
              diskSize = lib.mkForce "auto";
              additionalSpace = "10G";
            };
          })
        ];
        format = "qcow";
      };
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = [pkgs.age pkgs.ssh-to-age pkgs.sops pkgs.nh];
    };

    colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;
    colmena = import ./hosts/colmena.nix {inherit inputs;};

    formatter.${system} = pkgs.alejandra;
  };
}
