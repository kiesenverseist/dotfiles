{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    de.enable = lib.mkEnableOption "enables basic cli config";
  };

  imports = [
    ./hyprland
    inputs.caelestia-shell.homeManagerModules.default
    inputs.dms.homeModules.dank-material-shell
  ];
  # ] ++ lib.optionals config.de.enable [./hyprland];

  config = lib.mkIf config.de.enable {
    guiMinimal.enable = true;
    programming.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      pkgs.eww
      libnotify
      grim
      slurp
      pavucontrol
      pulsemixer
      wl-clipboard
      playerctl
      xdg-user-dirs
      gnome-calculator
      sushi
      gnome-solanum
      vlc
      waypipe
      nwg-displays
      rofi-pulse-select
      woomer
      kdePackages.qtdeclarative
      kdePackages.dolphin
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      # package = config.lib.nixGL.wrap pkgs.hyprland;
      # settings = {
      #   exec-once = [
      #     "${pkgs.kdePackages.xwaylandvideobridge}/bin/xwaylandvideobridge"
      #   ];
      # };
      systemd.variables = ["--all"];
    };

    # programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    services.hyprpolkitagent.enable = true;

    xdg.systemDirs.data = [
      "/var/lib/flatpak/exports/share"
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
      "${config.home.homeDirectory}/.nix-profile/share"
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    # programs.hyprpanel.enable = true;
    # programs.quickshell = {
    #   enable = false;
    #   activeConfig = "${config.home.homeDirectory}/dotfiles/config/quickshell";
    #   systemd.enable = true;
    # };

    programs.rofi.enable = false;

    programs.caelestia = {
      enable = false;
      systemd = {
        enable = true;
        target = "graphical-session.target";
        environment = [];
      };
      settings = {
        bar = {
          status = {
            showBattery = false;
            showBluetooth = false;
            showWifi = false;
            showMicrophone = true;
            showNetwork = false;
          };
          workspaces = {
            perMonitorWorkspaces = true;
            show = 10;
          };
        };
        paths.wallpaperDir = "~/Pictures/wallpapers/";
      };
      cli = {
        enable = true; # Also add caelestia-cli to path
        settings = {
          theme.enableGtk = false;
        };
      };
    };

    programs.dank-material-shell.enable = true;

    programs.qutebrowser = {
      enable = true;
      settings = {
        colors.webpage.darkmode.enabled = true;
        # fonts.default_size = "12pt";
        tabs = {
          position = "right";
          show = "switching";
        };
      };
      keyBindings = {
        normal = {
          "<Ctrl-v>" = "spawn mpv {url}";
          ",p" = "spawn --userscript qute-pass";
          ",l" = ''config-cycle spellcheck.languages ["en-AU"] ["en-GB"] ["en-US"]'';
          "tt" = "config-cycle tabs.show switching always";
        };
        prompt = {
          "<Ctrl-y>" = "prompt-yes";
        };
      };
      searchEngines = {
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/w/index.php?search={}";
        g = "https://www.google.com/search?hl=en&q={}";
        no = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=options&query={}";
        np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=options&query={}";
        ho = "https://home-manager-options.extranix.com/?={}";
      };
    };

    programs.zathura.enable = true;

    programs.mangohud.enable = true;

    services.swaync.enable = false;
    services.swayosd.enable = false;

    # remember to do the manual setup of this on first setup on computer
    services.syncthing = {
      enable = lib.mkDefault true;
      tray.enable = true;
    };

    services.udiskie.enable = true;
    services.network-manager-applet.enable = true;
    services.blueman-applet.enable = true;

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
