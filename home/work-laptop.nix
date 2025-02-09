{
  config,
  pkgs,
  lib,
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
    packages = lib.mkForce inputs.nixgl-stable.packages;
    # packages = lib.mkForce inputs.nixgl.packages;
    defaultWrapper = "mesa";
  };

  nix = {package = pkgs.nix;};

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
    # pkgs.nvtopPackages.amd

    ## desktop
    pkgs.xclip
    pkgs.brightnessctl

    ## hyprland desktop
    pkgs.wl-clipboard
    pkgs.eww
    pkgs.nwg-displays
    pkgs.hyprpanel
    pkgs.swww
    pkgs.grimblast
    pkgs.hyprsunset

    ## programming
    pkgs._1password-cli
    pkgs.minikube

    pkgs.jira-cli-go
    pkgs.slack

    ## nix stuff
    pkgs.nixgl.nixGLIntel
    # pkgs.nixgl.nixVulkanIntel
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

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

  wayland.windowManager.hyprland = let
    # pkgs-stable = pkgs;
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit (pkgs) system;
      overlays = [inputs.nixgl-stable.overlay];
    };
  in {
    package = lib.mkForce (config.lib.nixGL.wrap pkgs-stable.hyprland);

    plugins = lib.mkForce [
      pkgs-stable.hyprlandPlugins.hyprspace
      pkgs-stable.hyprlandPlugins.hyprbars
    ];

    settings = {
      input = {kb_options = ["ctrl:nocaps"];};
      exec-once = [
        "kwalletd6"
        "${pkgs.hyprpanel}/bin/hyprpanel"
        "[workspace special silent] NIXOS_OZONE_WL=1 ${pkgs.slack}/bin/slack"
        "[workspace 1 silent; group set] ${pkgs.floorp}/bin/floorp"
        "[workspace 2 silent] ${pkgs.neovide}/bin/neovide"
        "[workspace 3 silent] ${pkgs.kitty}/bin/kitty"
      ];
    };
  };

  programs.hyprlock.enable = true;

  targets.genericLinux.enable = true;

  xdg.systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];

  qt.enable = lib.mkForce false;
  gtk.enable = lib.mkForce false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
