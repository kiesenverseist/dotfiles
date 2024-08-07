{ inputs, pkgs, config, ... }:
let
  gruvboxplus = import ./packages/gruvbox-plus.nix {inherit pkgs;};
  # gaming = nix-gaming.packages.${pkgs.system};
  xwvb = pkgs.libsForQt5.callPackage ./packages/xwaylandvideobridge.nix {};
  # eww-custom = pkgs.callPackage ./eww-custom {};
  nixGl = import ./packages/nixgl.nix {inherit pkgs config;};
in {
  imports = [
    inputs.walker.homeManagerModules.walker
    ./modules
  ];

  guiMinimal.enable = true;
  programming.enable = true;

  nixGLPrefix = "nixGLIntel";

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
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # theming
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qt6ct

    # (eww-custom.override { withWayland = true; })
    # (pkgs.eww.override { withWayland = true; })
    # libnotify
    wpaperd
    xwvb # xwaylandvideobridge
    

    # syncthingtray
    rofi-power-menu
    rofi-pulse-select

    # proprietary stuffs
    vesktop
    # (discord.override {
    #   withOpenASAR = true;
    # })
    # obsidian
    # teams
    # microsoft-edge


  ];

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   settings = {
  #     "source" = "~/.config/hypr/main.conf";
  #   };
  #   systemd.variables = ["--all"];
  # };

  xdg.userDirs.enable = true;

  xdg.mimeApps.defaultApplications = {

  };

  # xdg.systemDirs.data = [
  #   "var/lib/flatpak/exports/share"
  #   "/home/kiesen/.local/share/flatpak/exports/share"
  # ];

  programs.kitty = {
    package = (nixGl pkgs.kitty);
  };

  programs.vscode = {
    enable =  true;
  };

  programs.git = {
    userName = "Ibrahim Fuad";
    userEmail = "creativeibi77@gmail.com";
  };
  

  services.swayosd = { enable = true; };

  programs.rofi = {
    enable = true;
  };

  programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    # config = {
    #   search.placeholder = "Example";
    #   ui.fullscreen = true;
    #   list = {
    #     height = 200;
    #   };
    #   websearch.prefix = "?";
    #   switcher.prefix = "/";
    # };

    # If this is not set the default styling is used.
    style = ''
      * {
        color: #dcd7ba;
      }
    '';
  };

  programs.qutebrowser = {
    enable = true;
    # package = pkgs.qutebrowser-qt6;
    settings = {
      colors.webpage.darkmode.enabled = true;
      fonts.default_size = "12pt";
      tabs = {
        position = "left";
        show = "switching";
      };
    };
  };

  # remember to do the manual setup of this on first setup on computer
  # services.syncthing = {
  #   enable = true;
  #   tray = {
  #     enable = true;
  #     command = "WAYLAND_DISPLAY= syncthingtray";
  #   };
  # };

  services.udiskie.enable = true;

  # services.network-manager-applet.enable = true;

 #  systemd.user.targets.tray = {
	# 	Unit = {
	# 		Description = "Home Manager System Tray";
	# 		Requires = [ "graphical-session-pre.target" ];
	# 	};
	# };

  targets.genericLinux.enable = true;

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;

    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3";

    iconTheme.package = gruvboxplus;
    iconTheme.name = "GruvboxPlus";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
