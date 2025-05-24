{
  config,
  pkgs,
  inputs,
  ...
}: let
  gruvboxplus = import ./packages/gruvbox-plus.nix {inherit pkgs;};
  xwvb = pkgs.libsForQt5.callPackage ./packages/xwaylandvideobridge.nix {};
  eww-custom = pkgs.callPackage ./packages/eww-custom {};
in {
  imports = [
    inputs.anyrun.homeManagerModules.anyrun
    inputs.hyprland.homeManagerModules.default
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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    gcalcli

    # de stuff
    (
      waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    )

    (eww-custom.override {withWayland = true;})
    # (pkgs.eww.override { withWayland = true; })
    libnotify
    wpaperd
    grim
    slurp
    pavucontrol
    pulsemixer
    yadm
    dolphin
    wl-clipboard
    playerctl
    xdg-user-dirs
    gnome-calculator
    nautilus
    sushi
    gnome-solanum
    xwvb # xwaylandvideobridge
    blueman
    zathura
    via
    chromium
    vlc
    obs-studio
    waypipe
    floorp

    # proprietary stuffs
    vesktop
    # teams
    # microsoft-edge
    todoist-electron
    slack
    slack-term

    # programming
    gf
    # clang
    postgresql
    sqlite
    minikube
    python39
    pulumi-bin
    # python3

    postman
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "source" = "~/.config/hypr/main.conf";
    };
    systemd.variables = ["--all"];
    plugins = [
      # inputs.hypr-darkwindow.packages.${pkgs.system}.Hypr-DarkWindow
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.systemDirs.data = [
    "var/lib/flatpak/exports/share"
    "/home/kiesen/.local/share/flatpak/exports/share"
  ];

  ## CLI Tools

  programs.git = {
    userName = "ibrahim.fuad";
    userEmail = "ibrahim.fuad@saberastro.com";
  };

  services.swayosd = {enable = true;};

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

  services.mako = {
    enable = true;
    anchor = "top-left";

    font = "Fira Nerd Font 12";

    padding = "5";

    backgroundColor = "#689d6a";
    progressColor = "#ebdbb2";
    textColor = "#1d2021";

    borderColor = "#ebdbb2";
    borderSize = 2;
    borderRadius = 5;
  };

  programs.awscli.enable = true;

  # services.udiskie.enable = true;

  services.network-manager-applet.enable = true;

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
    style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  gtk = {
    enable = true;

    theme.package = pkgs.adw-gtk3;
    theme.name = "adw-gtk3-dark";

    iconTheme.package = gruvboxplus;
    iconTheme.name = "GruvboxPlus";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
