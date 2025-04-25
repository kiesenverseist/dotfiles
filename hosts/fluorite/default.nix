{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./configuration.nix
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    inputs.sops-nix.nixosModules.sops
  ];
}
