{ pkgs, inputs, ... }:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.walker.homeManagerModules.default
    ./modules
  ];

  guiMinimal.enable = true;
  programming.enable = true;
  cli.enable = true;

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

  # programs.bash.enable = true;

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

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "source" = "~/.config/hypr/main.conf";
      "monitor" = [
        "eDP1, preferred, 0x1440, 1"
        "HDMI-A-1, preferred, 0x0, 1.333333"
      ];
    };
    systemd.variables = ["--all"];
    plugins = [
      # inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };

  programs.walker = {
    enable = true;
    runAsService = true;
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
