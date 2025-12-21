{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./modules
    inputs.stylix.homeModules.stylix
  ];

  de.enable = true;
  theme.enable = false;
  guiMinimal.enable = true;
  programming.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "talux";
  home.homeDirectory = "/home/talux";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # pkgs.pdfslicer
    pkgs.virt-viewer
    pkgs.claude-code
    pkgs.slack

    pkgs.bun
    pkgs.vtsls
    pkgs.awscli2
    pkgs.mongodb-compass
  ];

  programs.git = {
    settings.user = {
      name = "Ibrahim Fuad";
      email = "ibrahim@taluxiq.com";
    };
    signing = {
      format = "ssh";
      signByDefault = true;
    };
  };

  services.syncthing.enable = false;

  gtk.enable = lib.mkForce false;
  qt.enable = lib.mkForce false;
}
