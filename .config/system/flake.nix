{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-master.url = "github:nixos/nixpkgs/master";
    # nixpkgs-stable.url = github:nixos/nixpkgs;

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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

    walker.url = "github:abenz1267/walker";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs = {...}@inputs:
  let 
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
      overlays = [inputs.nixgl.overlay];
    };

    # pkgs-master = import inputs.nixpkgs-master {
    #   inherit system;
    #   config = {
    #       allowUnfree = true;
    #   };
    # };

  in {
    nixosConfigurations = let 
      specialArgs = {inherit inputs system;};
      conf = attrs: inputs.nixpkgs.lib.nixosSystem ({
        inherit specialArgs;
      } // attrs);
    in {
      "halite" = conf {
        modules = [ ./hosts/halite ];
      };
      "graphite" = conf {
        modules = [
          ./hosts/graphite
          inputs.foundryvtt.nixosModules.foundryvtt
          inputs.lix-module.nixosModules.default
          inputs.nixos-hardware.nixosModules.common-gpu-amd
        ];
      };
      "live" = conf {
        inherit system;
        modules = [
          (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./hosts/live
        ];
      };
    };

    homeConfigurations = let
      extraSpecialArgs = { inherit inputs; };
      conf = attrs: inputs.home-manager.lib.homeManagerConfiguration ({
          inherit pkgs extraSpecialArgs; 
      } // attrs);
      commonModules = [ inputs.stylix.homeManagerModules.stylix ];
    in {
      "kiesen@halite" = conf {
        modules = [ ./home/home-halite.nix ] ++ commonModules;

        extraSpecialArgs = extraSpecialArgs // { 
          nix-gaming = inputs.nix-gaming;
        };
      };
      "kiesen@graphite" = conf {
        modules = [ ./home/home-graphite.nix ] ++ commonModules;
      };
      "kiesen@kiesen-eos-laptop" = conf {
        modules = [ ./home/home-laptop.nix ] ++ commonModules;
      };
      "ibrahim.fuad@au-lap-0618.saberastronautics.net" = conf {
        modules = [ ./home/work-laptop.nix ] ++ commonModules;
      };
      "ibrahim.fuad@graphite" = conf {
        modules = [ ./home/work-graphite.nix ] ++ commonModules;
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
