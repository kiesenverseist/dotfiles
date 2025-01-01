{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./modules
    ./modules/plasma.nix
  ];

  guiMinimal.enable = true;
  programming.enable = true;
  cli.enable = true;
  private-cache.enable = false;
  walker.enable = true;
  de.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ibrahim.fuad";
  home.homeDirectory = "/home/ibrahim.fuad";

  # nixgl config
  nixGL = {
    packages = inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
    ## cli stuff
    pkgs.nvtopPackages.amd

    ## desktop
    pkgs.xclip

    ## hyprland desktop
    pkgs.wl-clipboard
    pkgs.eww
    pkgs.nwg-displays

    ## programming
    pkgs._1password-cli
    pkgs.minikube

    pkgs.jira-cli-go

    ## nix stuff
    pkgs.nixgl.nixGLIntel
    pkgs.nixgl.nixVulkanIntel
  ];

  # programs.bash.enable = true;
  programs.bash.profileExtra = ''
    source .config/secrets
  '';

  programs.vscode = {
    enable = true;
  };

  programs.git = {
    userName = "ibrahim.fuad";
    userEmail = "ibrahim.fuad@saberastro.com";
  };

  programs.rofi = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  qt.enable = true;
  gtk.enable = true;

  targets.genericLinux.enable = true;

  xdg.systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
