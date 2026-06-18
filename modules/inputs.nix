{
  flake-file.inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
    };

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };

}
