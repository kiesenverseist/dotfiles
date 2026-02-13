{
  pkgs,
  lib,
  ...
}: {
  de.enable = true;
  guiMinimal.enable = true;
  programming.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kiesen";
  home.homeDirectory = "/home/kiesen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.discord
    pkgs.ferdium
    # pkgs.pdfslicer

    (pkgs.prismlauncher.override {jdks = [pkgs.jdk25];})

    pkgs.prusa-slicer
    pkgs.freecad

    pkgs.virt-viewer

    pkgs.sdrpp
  ];

  programs.git.settings.user = {
    name = "Ibrahim Fuad";
    email = "creativeibi77@gmail.com";
  };

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  gtk.enable = lib.mkForce false;
  qt.enable = lib.mkForce false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
