{ lib, ... }:

{
  imports = [
    ./cli.nix
    ./gui.nix
    # ./de.nix
    ./programming.nix
    ./hyprland
    ./theme.nix
  ];

  cli.enable = lib.mkDefault true;
  theme.enable = lib.mkDefault true;
}
