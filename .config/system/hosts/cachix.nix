{
  pkgs,
  lib,
  ...
}: let
  folder = ./cachix;
  toImport = name: value: folder + ("/" + name);
  filterCaches = key: value: value == "regular" && lib.hasSuffix ".nix" key;
  imports = lib.mapAttrsToList toImport (lib.filterAttrs filterCaches (builtins.readDir folder));
in {
  inherit imports;

  private-cache.enable = lib.mkDefault true;

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];

  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  nix.settings = {
    connect-timeout = 1;
    fallback = true;
    log-lines = 25;
    min-free = 128000000;
    max-free = 1000000000;
    auto-optimise-store = true;
  };
}
