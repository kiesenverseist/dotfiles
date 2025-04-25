{lib, ...}: {
  imports = [
    ./cli.nix
    ./gui.nix
    ./de.nix
    ./programming.nix
    ./theme.nix
    ./walker.nix
    ../../hosts/modules/cachix.nix
  ];

  cli.enable = lib.mkDefault true;
  theme.enable = lib.mkDefault true;
}
