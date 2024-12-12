{
  config,
  pkgs,
  inputs,
  ...
}: let
  gruvboxplus = import ./packages/gruvbox-plus.nix {inherit pkgs;};
  gdlauncher = import ./packages/gdlauncher.nix {inherit pkgs;};
  # lmms-nightly = import ./packages/lmms.nix {inherit pkgs;};
  # gaming = inputs.nix-gaming.packages.${pkgs.system};
  # xwvb = pkgs.libsForQt5.callPackage ./packages/xwaylandvideobridge.nix {};
  eww-custom = pkgs.callPackage ./packages/eww-custom {};
in {
  imports = [
    inputs.anyrun.homeManagerModules.anyrun
    ./modules
  ];

  guiMinimal.enable = true;
  programming.enable = true;
  # de.enable = false;
  walker.enable = true;

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
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # cli stuff
    nvtopPackages.full
    lf
    ctpv

    (eww-custom.override {withWayland = true;})
    # (pkgs.eww.override { withWayland = true; })
    libnotify
    wpaperd
    grim
    slurp
    pavucontrol
    pulsemixer
    dolphin
    wl-clipboard
    playerctl
    xdg-user-dirs
    qbittorrent
    gnome-calculator
    nautilus
    sushi
    gnome-solanum
    xwaylandvideobridge # xwvb
    blueman
    zathura
    via
    chromium
    vlc
    # obs-studio
    waypipe
    nwg-displays
    nwg-dock-hyprland
    walker

    # lmms
    # ardour
    # lmms-nightly
    # distrho # TODO: broke, check.
    cardinal
    vcv-rack
    carla

    syncthingtray

    # proprietary stuffs
    vesktop
    (discord.override {
      withOpenASAR = false;
    })
    # teams
    # microsoft-edge

    # programming
    gf
    postgresql
    sqlite

    # gaming
    protontricks
    # gaming.proton-ge
    # gaming.osu-stable # TODO: broke, check
    # gaming.osu-lazer-bin # TODO: broke, check
    gdlauncher
    prismlauncher
    wine
    lutris
    moonlight-qt
    protonup-qt
    looking-glass-client
    runelite
    modrinth-app
    bottles
    xivlauncher

    libva
    vaapiVdpau
    libvdpau-va-gl
    libva-utils
    #nvapi latencyflex

    # game dev
    pixelorama
    # unityhub
    godot_4

    # making
    prusa-slicer
    kicad
    freecad-wayland

    edl

    inputs.nix-alien.packages.${system}.nix-alien
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
      "source" = [
        "~/.config/hypr/main.conf"
        "~/.config/hypr/monitors.conf"
      ];
    };
    systemd.variables = ["--all"];
    plugins = [
      pkgs.hyprlandPlugins.hyprspace
      pkgs.hyprlandPlugins.hyprbars
    ];
  };

  # programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  xdg.mimeApps.defaultApplications = {
  };

  xdg.systemDirs.data = [
    "var/lib/flatpak/exports/share"
    "/home/kiesen/.local/share/flatpak/exports/share"
  ];

  programs.vscode = {
    enable = true;
  };

  ## CLI Tools

  programs.git = {
    userName = "Ibrahim Fuad";
    userEmail = "creativeibi77@gmail.com";
  };

  # programs.lf = {
  #   enable = true;
  # };

  services.swayosd = {enable = true;};

  programs.anyrun = {
    enable = false;
    config = {
      plugins = let
        anyrun-plugins = inputs.anyrun.packages.${pkgs.system};
      in [
        anyrun-plugins.applications
        anyrun-plugins.randr
      ];
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      layer = "overlay";
      showResultsImmediately = true;
      closeOnClick = true;
    };
  };

  programs.rofi.enable = true;

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

  programs.mangohud = {
    enable = true;
  };

  services.mako = {
    enable = false;
    anchor = "top-left";

    font = "Fira Nerd Font 12";

    padding = "5";

    backgroundColor = "#1D2021";
    progressColor = "#ebdbb2";
    textColor = "#d4be98";

    borderColor = "#ebdbb2";
    borderSize = 2;
    borderRadius = 5;
  };

  services.swaync.enable = true;

  # remember to do the manual setup of this on first setup on computer
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "WAYLAND_DISPLAY= syncthingtray";
    };
  };

  # services.udiskie.enable = true;

  services.network-manager-applet.enable = true;

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  qt = {
    enable = true;
    # platformTheme.name = "gtk";
    # style.name = "adwaita-dark";
    # style.package = pkgs.adwaita-qt;
  };

  home.pointerCursor = {
    # gtk.enable = true;
    # x11.enable = true;
    # package = pkgs.bibata-cursors;
    # name = "Bibata-Modern-Ice";
    # size = 16;
  };

  gtk = {
    enable = true;

    # theme.package = pkgs.adw-gtk3;
    # theme.name = "adw-gtk3-dark";

    iconTheme.package = gruvboxplus;
    iconTheme.name = "GruvboxPlus";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
