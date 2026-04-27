{inputs, ...}: {
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  systems = ["x86_64-linux"];

  imports = [
    ../home
    inputs.flake-file.flakeModules.default
    inputs.flake-file.flakeModules.import-tree
  ];


  flake = {
    nixosConfigurations = {
      iso = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
          ({pkgs, ...}: {
            environment.systemPackages = [pkgs.keyutils];
            boot.supportedFilesystems = ["bcachefs"];
            programs.tmux.enable = true;
            programs.neovim.enable = true;
          })
        ];
      };
    };
  };

  flake-file.outputs = "inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)";
}
