{lib, ...}: {
  imports = [
    ./cli.nix
    ./gui.nix
    # ./de.nix
    ./programming.nix
    ./hyprland
    ./theme.nix
    ./walker.nix
    ../../hosts/cachix.nix
  ];

  cli.enable = lib.mkDefault true;
  theme.enable = lib.mkDefault true;
}
