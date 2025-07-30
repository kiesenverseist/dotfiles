{
  lib,
  inputs,
  ...
}: {
  imports = [
    ./configuration.nix
    ./game-servers.nix
    ./vfio.nix
    ./pg.nix
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  vfio.enable = lib.mkDefault true;
  specialisation."NO_VFIO".configuration = {
    system.nixos.tags = ["without-vfio"];
    vfio.enable = false;
  };
}
