{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  boot.supportedFilesystems = ["bcachefs"];
  boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_testing_bcachefs;
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
