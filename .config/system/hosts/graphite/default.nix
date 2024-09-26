
{ config, lib, pkgs, system, ... }:

{
  imports = [
    ./configuration.nix
    # ./vfio.nix
    # ./nvidia.nix
  ];

  # vfio.enable = lib.mkDefault true;
  # specialisation."NO_VFIO".configuration = {
  #   system.nixos.tags = ["without-vfio"];
  #   vfio.enable = false;
  # };
}
