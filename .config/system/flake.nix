{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixos-nvidia-vgpu.url = "github:Yeshey/nixos-nvidia-vgpu/master";
    # hypr-plugins.url = "github:nehrbash/sn-hyprland-plugins";

  };

  outputs = { self, nixpkgs}@inputs:
  let 
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
          allowUnfree = true;
      };


    };
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
            # nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
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
