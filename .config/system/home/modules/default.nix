{ lib, ... }:

{
  imports = [
    ./cli.nix
    ./gui.nix
    # ./de.nix
    ./programming.nix
    ./hyprland
  ];

  cli.enable = lib.mkDefault true;
}
