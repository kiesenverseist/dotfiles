{lib, ...}: {
  imports = [
    ./configuration.nix
    ./game-servers.nix
    ./vfio.nix
	./pg.nix
  ];

  vfio.enable = lib.mkDefault true;
  specialisation."NO_VFIO".configuration = {
    system.nixos.tags = ["without-vfio"];
    vfio.enable = false;
  };
}
