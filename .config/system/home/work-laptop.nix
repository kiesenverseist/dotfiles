{ pkgs, ... }:
{
  imports = [
    ./modules
  ];

  guiMinimal.enable = true;
  programming.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ibrahim.fuad";
  home.homeDirectory = "/home/ibrahim.fuad";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ## cli stuff
    nvtopPackages.amd
    
    ## desktop
    xclip

    ## programming
    _1password
    minikube

    ## nix stuff
    nixgl.nixGLIntel
  ];


  programs.vscode = {
    enable =  true;
  };

  programs.git = {
    userName = "ibrahim.fuad";
    userEmail = "ibrahim.fuad@saberastro.com";
  };


  programs.rofi = {
    enable = true;
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
