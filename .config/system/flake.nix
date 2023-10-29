{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    # nixpkgs-stable.url = github:nixos/nixpkgs;

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixos-nvidia-vgpu.url = "github:Yeshey/nixos-nvidia-vgpu/master";
    # hypr-plugins.url = "github:nehrbash/sn-hyprland-plugins";

    # peerix = {
    #   url = github:cid-chan/peerix;
    #   inputs.nixpkgs.follows = "nixpkgs-stable";
    # };

    # nix-serve-ng.url = github:aristanetworks/nix-serve-ng;

  };

  outputs = {self, nixpkgs, nixos-hardware}@inputs:
  let 
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
          allowUnfree = true;
      };
    
    };

    # px = peerix.nixosModules.peerix {
    #   services.peerix = {
    #     enable = true;
    #     package = peerix.packages.${system}.peerix;
    #     openFirewall = true;
    #     privateKeyFile = ./hosts/peerix-private;
    #     publicKeyFile = ./hosts/peerix-public;
    #     publicKey = "
    #       peerix-graphite:W0rigmVaZfW12WTkDyegBvhnZvp6EEpBilrwuUs/x9w=
    #       peerix-halite:P4oCmaTSf2JHnw1DtRKOMMuf4TEoITd9T0V4cAKRObo= 
    #     ";
    #   };
    # };

  in {
    nixosConfigurations = {
      "halite" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};

        modules = [
          ./hosts/halite
          # nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
        ];
      };
      "graphite" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};

        modules = [
          ./hosts/graphite
          # nix-serve-ng.nixosModules.default {services.nix-serve.enable=true;}
        ];
      };
      "live" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system;};
        inherit system;
        modules = [
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./hosts/live
        ];
      };
    };
  };
}
