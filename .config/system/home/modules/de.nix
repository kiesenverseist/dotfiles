{ config, pkgs, lib, nix-gaming, nix-alien, inputs, ... }:
let
  gruvboxplus = import ./packages/gruvbox-plus.nix {inherit pkgs;};
  gdlauncher = import ./packages/gdlauncher.nix {inherit pkgs;};
  # lmms-nightly = import ./packages/lmms.nix {inherit pkgs;};
  gaming = nix-gaming.packages.${pkgs.system};
  xwvb = pkgs.libsForQt5.callPackage ./packages/xwaylandvideobridge.nix {};
  eww-custom = pkgs.callPackage ./packages/eww-custom {};
  # godot-wayland = import ./packages/godot-wayland.nix {inherit pkgs;};
in {
  options = {
    de.enable = lib.mkEnableOption "enables basic cli config";
  };

  imports = [
    inputs.anyrun.homeManagerModules.anyrun
    inputs.walker.homeManagerModules.walker
  ];

  config = lib.mkIf config.de.enable {
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
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      (pkgs.nerdfonts.override { fonts = [ 
        "FiraCode"
        "Gohu"
      ]; })
      # font-awesome
      # comic-mono
      # cartograph

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')

      # cli stuff
      nvtopPackages.amd
      lazygit
      lf ctpv

      (eww-custom.override { withWayland = true; })
      # (pkgs.eww.override { withWayland = true; })
      libnotify
      wpaperd
      grim slurp
      pavucontrol
      pulsemixer
      yadm
      dolphin
      wl-clipboard
      playerctl
      xdg-user-dirs
      qbittorrent
      gnome.gnome-calculator
      gnome.nautilus
      gnome.sushi
      gnome-solanum
      xwvb # xwaylandvideobridge
      blueman
      zathura
      via
      chromium
      vlc obs-studio
      waypipe
      floorp

      # lmms
      # ardour
      # lmms-nightly
      distrho
      cardinal
      vcv-rack
      carla

      syncthingtray
      # rofi-power-menu
      # rofi-pulse-select

      # proprietary stuffs
      vesktop
      (discord.override {
        withOpenASAR = false;
      })
      (obsidian.override {
        electron = electron_24;
      })
      # teams
      # microsoft-edge
      todoist-electron

      # programming
      cachix
      neovide
      gf
      # clang 
      postgresql
      sqlite
      texlab
      tectonic
      # (import (fetchTarball https://install.devenv.sh/latest)).default


      # gaming
      protontricks
      # gaming.proton-ge
      gaming.osu-stable
      gaming.osu-lazer-bin
      gdlauncher
      prismlauncher
      wine
      lutris
      moonlight-qt
      protonup-qt
      looking-glass-client
      runelite
      modrinth-app

      libva vaapiVdpau libvdpau-va-gl
  #nvapi latencyflex

      # game dev
      godot_4
      # godot-wayland.godot-wayland
      pixelorama
      # unityhub
      
      # making
      prusa-slicer
      kicad


      nix-alien
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
    
    fonts.fontconfig.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "source" = "~/.config/hypr/main.conf";
      };
      systemd.variables = ["--all"];
      # plugins = [
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      # ];
    };


    # You can also manage environment variables but you will have to manually
    # source
    #
    #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    #
    # or
    #
    #  /etc/profiles/per-user/kiesen/etc/profile.d/hm-session-vars.sh
    #
    # if you don't want to manage your shell through Home Manager.

    xdg.mimeApps.defaultApplications = {

    };

    xdg.systemDirs.data = [
      "var/lib/flatpak/exports/share"
      "/home/kiesen/.local/share/flatpak/exports/share"
    ];

    programs.vscode = {
      # enable =  true;
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        jdinhlife.gruvbox
        # ms-python.python
        # ms-toolsai.jupyter
        ms-vsliveshare.vsliveshare
      ];
    };

    ## CLI Tools


    programs.git = {
      userName = "Ibrahim Fuad";
      userEmail = "creativeibi77@gmail.com";
    };

    # programs.lf = {
    #   enable = true;
    # };

    services.swayosd = { enable = true; };

    # programs.rofi = {
    #   enable = true;
    #   package = pkgs.rofi-wayland;
    #   plugins = with pkgs;[
    #       rofi-calc
    #       rofi-file-browser
    #   ];
    #   cycle = true;
    #   # font = "FiraCode Nerd Font 16";
    #   font = "GohuFont uni11 Nerd Font Propo 22";
    #   terminal = "${pkgs.kitty}/bin/kitty";
    #   theme =  let 
    #     inherit (config.lib.formats.rasi) mkLiteral;
    #   in {
    #     "@theme" = "gruvbox-dark-hard";
    #     element-icon = {
    #       size = mkLiteral "2.5ch";
    #     };
    #   };
    #   extraConfig = let 
    #     inherit (config.lib.formats.rasi) mkLiteral;
    #   in {
    #     # modes = "window,drun,run,ssh,calc,recursivebrowser";
    #     modes = "window,drun,run,ssh";
    #   };
    # };

    # programs.anyrun = {
    #   enable = true;
    #   config =  {
    #     plugins =let
    #       anyrun-plugins = inputs.anyrun.packages.${pkgs.system};
    #     in [
    #       anyrun-plugins.applications
    #       anyrun-plugins.randr
    #     ];
    #     x = {fraction = 0.5;};
    #     y = {fraction = 0.3;};
    #     layer = "overlay";
    #     showResultsImmediately = true;
    #     closeOnClick = true;
    #   };
    # };

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

    programs.mangohud = {
      enable = true;
    };
    
    # services.mako = {
    #   enable = true;
    #   anchor = "top-left";
    #
    #   font= "Fira Nerd Font 12";
    #
    #   padding="5";
    #
    #   backgroundColor="#1D2021";
    #   progressColor="#ebdbb2";
    #   textColor="#d4be98";
    #
    #   borderColor="#ebdbb2";
    #   borderSize=2;
    #   borderRadius=5;
    # };

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
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    qt.enable = true;

    qt.platformTheme = "gtk";
    qt.style.name = "adwaita-dark";
    qt.style.package = pkgs.adwaita-qt;

    gtk.enable = true;

    gtk.cursorTheme.package = pkgs.bibata-cursors;
    gtk.cursorTheme.name = "Bibata-Modern-Ice";

    gtk.theme.package = pkgs.adw-gtk3;
    gtk.theme.name = "adw-gtk3-dark";

    gtk.iconTheme.package = gruvboxplus;
    gtk.iconTheme.name = "GruvboxPlus";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
