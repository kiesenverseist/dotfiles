{
  flake-file.inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # TODO: remove when https://github.com/NixOS/nixpkgs/pull/332296 is merged
    otbr.url = "github:mrene/nixpkgs/openthread-border-router";

    devenv.url = "github:cachix/devenv";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
    };

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    hyprhook = {
      url = "github:hyprhook/hyprhook";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
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

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  

}
