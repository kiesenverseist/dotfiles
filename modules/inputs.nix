{
  flake-file = {
    inputs = {
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

      nixos-hardware = {
        url = "github:NixOS/nixos-hardware/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-gaming = {
        url = "github:fufexan/nix-gaming";
        inputs.flake-parts.follows = "flake-parts";
      };

      nixpkgs-xr = {
        url = "github:nix-community/nixpkgs-xr";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      foundryvtt.url = "github:reckenrode/nix-foundryvtt";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";

      nixos-generators = {
        url = "github:nix-community/nixos-generators";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    };
    nixConfig = {
      extraSubstituters = [
        "https://install.determinate.systems"
      ];
      extraTrustedPublicKeys = [
        "https://install.determinate.systems"
      ];
    };
  };
}
