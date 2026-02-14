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
    inputs.dms.homeModules.dank-material-shell
  ];

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
      kdePackages.kwallet
      kdePackages.kwalletmanager
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.variables = ["--all"];
    };

    # programs.hyprlock.enable = true;
    # services.hypridle.enable = true;
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

    # programs.quickshell = {
    #   enable = false;
    #   activeConfig = "${config.home.homeDirectory}/dotfiles/config/quickshell";
    #   systemd.enable = true;
    # };

    programs.rofi.enable = false;

    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;

      plugins = {
        HyprlandSubmap = {
          src = pkgs.fetchFromGitHub {
            owner = "mesteryui";
            repo = "DMS_HyprlandSubmap";
            rev = "main";
            sha256 = "sha256-EJ8MCxnA/eZUccUf7EG6N8hPHblTXSlgXfxwLy/Jt8s=";
          };
        };
      };
    };

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
      tray.enable = lib.mkDefault true;
    };

    services.udiskie.enable = true;
    # services.network-manager-applet.enable = true;
    # services.blueman-applet.enable = true;

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    home.file = let
      dotfiles = "${config.home.homeDirectory}/dotfiles";
      sym = dir: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/${dir}";
    in {
      ".config/quickshell".source = sym "quickshell";

      ".config/hypr/main.conf".source = sym "hypr/main.conf";
      ".config/hypr/bindings.conf".source = sym "hypr/bindings.conf";
      ".config/hypr/plugins.conf".source = sym "hypr/plugins.conf";
      ".config/hypr/zoom".source = sym "hypr/zoom";
    };
  };
}
