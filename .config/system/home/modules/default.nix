{ lib, ... }:

{
  imports = [
    ./cli.nix
    ./gui.nix
    # ./de.nix
    ./programming.nix
  ];

  cli.enable = lib.mkDefault true;
}
