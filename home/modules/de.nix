{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    de.enable = lib.mkEnableOption "enables basic cli config";
  };

  imports = [
    ./hyprland
  ];
  # ] ++ lib.optionals config.de.enable [./hyprland];

  config = lib.mkIf config.de.enable {
    guiMinimal.enable = true;
    programming.enable = true;
    walker.enable = true;

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      # cli stuff
      # nvtopPackages.full

      pkgs.eww
      wpaperd
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
      gnome-calculator
      nautilus
      sushi
      gnome-solanum
      xwaylandvideobridge # xwvb
      blueman
      vlc
      waypipe
      nwg-displays
      walker

      hyprpolkitagent

      syncthingtray
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.hyprland;
      settings = {
        "source" = [
          "~/.config/hypr/main.conf"
          "~/.config/hypr/monitors.conf"
        ];
      };
      systemd.variables = ["--all"];
      plugins = [
        # pkgs.hyprlandPlugins.hyprspace
        pkgs.hyprlandPlugins.hyprbars
      ];
    };

    # programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    xdg.systemDirs.data = [
      "var/lib/flatpak/exports/share"
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    ];

    ## CLI Tools

    # programs.lf = {
    #   enable = true;
    # };

    services.swayosd = {enable = true;};

    programs.rofi.enable = true;

    programs.qutebrowser = {
      enable = true;
      settings = {
        colors.webpage.darkmode.enabled = true;
        fonts.default_size = "12pt";
        tabs = {
          position = "left";
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
        nw = "https://wiki.nixos.org/index.php?search={}";
        g = "https://www.google.com/search?hl=en&q={}";
        no = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=options&query={}";
        np = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=options&query={}";
        hm = "https://home-manager-options.extranix.com/?={}";
      };
    };

    programs.zathura.enable = true;

    programs.mangohud = {
      enable = true;
    };

    # services.swaync.enable = true;

    # remember to do the manual setup of this on first setup on computer
    services.syncthing = {
      enable = true;
      tray = {
        enable = true;
      };
    };

    services.udiskie.enable = true;
    services.network-manager-applet.enable = true;

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

    systemd.user.services.hyprpolkitagent = {
      Install = {WantedBy = ["graphical-session.target"];};
    };
  };
}
