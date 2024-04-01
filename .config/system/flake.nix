{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    # nixpkgs-stable.url = github:nixos/nixpkgs;

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {self, nixos-hardware, ...}@inputs:
  let 
    system = "x86_64-linux";

    pkgs = import inputs.nixpkgs {
      inherit system;

      config = {
          allowUnfree = true;
      };
    
    };

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
  };
}
