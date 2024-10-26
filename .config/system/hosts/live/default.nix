{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.supportedFilesystems = ["bcachefs"];
  boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_testing_bcachefs;
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
