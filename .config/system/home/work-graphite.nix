{ config, pkgs, inputs, ... }:
let
  gruvboxplus = import ./packages/gruvbox-plus.nix {inherit pkgs;};
  xwvb = pkgs.libsForQt5.callPackage ./packages/xwaylandvideobridge.nix {};
  eww-custom = pkgs.callPackage ./packages/eww-custom {};
in {
  imports = [
    inputs.anyrun.homeManagerModules.anyrun
  ];


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

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ 
      "FiraCode"
      "Gohu"
    ]; })

    # cli stuff
    btop 
    nvtopPackages.amd
    curl
    lazygit
    atool unzip
    bc
    lf ctpv
    socat jq
    zstd

    gcalcli

    # de stuff
    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    )
    
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
    gnome-calculator
    nautilus
    sushi
    gnome-solanum
    xwvb # xwaylandvideobridge
    blueman
    zathura
    via
    chromium
    vlc obs-studio
    waypipe
    floorp

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
    nodejs
    go
    devenv
    minikube
    python39
    python3

    nh
    nix-output-monitor

    # making
    prusa-slicer
    kicad
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
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    FLAKE = "$HOME/.config/system";
  };

  xdg.userDirs.enable = true;

  xdg.mimeApps.defaultApplications = {

  };

  xdg.systemDirs.data = [
    "var/lib/flatpak/exports/share"
    "/home/kiesen/.local/share/flatpak/exports/share"
  ];

  programs.kitty = {
    enable = true;
    # theme = "Gruvbox Material Dark Hard";
    theme = "Rosé Pine";
    font = {
      name = "FiraCode Nerd Font";
      size = 16;
    };
    settings = {
      background_opacity = "0.8";
    };
    shellIntegration.enableFishIntegration = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
  };

  programs.fish = {
    enable = true;
    functions = {
      icat = {
        body = "kitten icat $argv[1]";
      };
      kssh = {
        body = "kitten ssh $argv";
      };
    };
    interactiveShellInit = ''
      zoxide init fish --cmd=cd | source
      fish_hybrid_key_bindings
    '';
  };

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      right_format = "$time";
    };
  };

  programs.nix-index.enable = true;
  # programs.command-not-found.enable = true;

  programs.vscode = {
    enable =  true;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      jdinhlife.gruvbox
      # ms-python.python
      # ms-toolsai.jupyter
      ms-vsliveshare.vsliveshare
    ];
  };

  ## CLI Tools

  programs.pyenv = { enable = true; };

  programs.direnv = { 
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = { 
    enable = true;
    enableFishIntegration = false;
  };

  programs.ripgrep = { enable = true; };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    git = true;
    icons = true;
  };

  programs.bat.enable = true;
    
  programs.git = {
    enable = true;
    userName = "ibrahim.fuad";
    userEmail = "ibrahim.fuad@saberastro.com";
    delta.enable = true;
    lfs.enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  services.swayosd = { enable = true; };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs;[
        rofi-calc
        rofi-file-browser
    ];
    cycle = true;
    # font = "FiraCode Nerd Font 16";
    font = "GohuFont uni11 Nerd Font Propo 22";
    terminal = "${pkgs.kitty}/bin/kitty";
    theme =  let 
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "@theme" = "gruvbox-dark-hard";
      element-icon = {
        size = mkLiteral "2.5ch";
      };
    };
    extraConfig = let 
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      # modes = "window,drun,run,ssh,calc,recursivebrowser";
      modes = "window,drun,run,ssh";
    };
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

  services.mako = {
    enable = true;
    anchor = "top-left";

    font= "Fira Nerd Font 12";

    padding="5";

    backgroundColor="#689d6a";
    progressColor="#ebdbb2";
    textColor="#1d2021";

    borderColor="#ebdbb2";
    borderSize=2;
    borderRadius=5;
  };

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

  systemd.user.targets.tray = {
		Unit = {
			Description = "Home Manager System Tray";
			Requires = [ "graphical-session-pre.target" ];
		};
	};

  qt.enable = true;

  qt.platformTheme.name = "gtk";
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
}
