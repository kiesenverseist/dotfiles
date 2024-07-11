{ config, pkgs, ... }:
let
  gruvboxplus = import ./common/gruvbox-plus.nix {inherit pkgs;};
  # gdlauncher = import ./gdlauncher.nix {inherit pkgs;};
  # gaming = nix-gaming.packages.${pkgs.system};
  xwvb = pkgs.libsForQt5.callPackage ./common/xwaylandvideobridge.nix {};
  # eww-custom = pkgs.callPackage ./eww-custom {};
in {
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

    # theming
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qt6ct

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # cli stuff
    # btop nvtop
    # curl
    # lazygit
    # atool unzip
    # bc
    # lf ctpv
    # socat jq
    # clipse

    # de stuff
    # (pkgs.waybar.overrideAttrs (oldAttrs: {
    #     mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #   })
    # )
    
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

    # programming
    cachix
    # neovide
    # gf
    # clang 
    # unityhub
    # postgresql
    # sqlite
    nixd
    nh
    nix-output-monitor

    # gaming
    # protontricks
    # gaming.proton-ge
    # gaming.osu-stable
    # gaming.osu-lazer-bin
    # gdlauncher
    # prismlauncher
    # wine
    # lutris

#nvapi latencyflex

    # game dev
    # godot_4
    # pixelorama
    
    # making
    # prusa-slicer
    # kicad

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
    FLAKE = "/home/kiesen/.config/system";
    # OBSIDIAN_REST_API_KEY = "6fcd1a7903cd6146397f0c76634f71440e7609a34866865a04d4535dfc3878d3";
  };

  xdg.userDirs.enable = true;

  xdg.mimeApps.defaultApplications = {

  };

  # xdg.systemDirs.data = [
  #   "var/lib/flatpak/exports/share"
  #   "/home/kiesen/.local/share/flatpak/exports/share"
  # ];

  # programs.kitty = {
  #   package = {};
  #   enable = true;
  #   theme = "Gruvbox Material Dark Hard";
  #   font = {
  #     name = "FiraCode Nerd Font";
  #     size = 16;
  #   };
  #   settings = {
  #     background_opacity = "0.8";
  #   };
  #   shellIntegration.enableFishIntegration = true;
  # };

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
        body = "kitty +kitten icat $argv[1]";
      };
      kssh = {
        body = "kitty +kitten ssh $argv";
      };
    };
    interactiveShellInit = ''
      zoxide init fish --cmd=cd | source
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

  programs.vscode = {
    enable =  true;
    extensions = with pkgs.vscode-extensions; [
      arrterian.nix-env-selector
      jdinhlife.gruvbox
      ms-python.python
      ms-toolsai.jupyter
      ms-vsliveshare.vsliveshare
    ];
  };

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
    git = true;
    icons = true;
  };

  programs.bat.enable = true;

  programs.git = {
    enable = true;
    userName = "Ibrahim Fuad";
    userEmail = "creativeibi77@gmail.com";
    delta.enable = true;
    lfs.enable = true;
  };
  
  # programs.lf = {
  #   enable = true;
  # };

  programs.fzf.enable = true;

  programs.gh.enable = true;

  services.swayosd = { enable = true; };

  programs.rofi = {
    enable = true;
    package = (pkgs.rofi-wayland.override {
      plugins = with pkgs;[
        rofi-calc
        rofi-file-browser
      ];
    });
    cycle = true;
    # font = "FiraCode Nerd Font 16";
    font = "GohuFont uni11 Nerd Font Propo 22";
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "gruvbox-dark-hard";
    extraConfig = {
      # modes = "window,drun,run,ssh,calc,file-browser-extended";
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

  # programs.mangohud = {
  #   enable = true;
  # };
  
  # services.mako = {
  #   enable = true;
  #   anchor = "top-left";
  #
  #   font= "Fira Nerd Font 12";
  #
  #   padding="5";
  #
  #   backgroundColor="#689d6a";
  #   progressColor="#ebdbb2";
  #   textColor="#1d2021";
  #
  #   borderColor="#ebdbb2";
  #   borderSize=2;
  #   borderRadius=5;
  # };

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

  qt.enable = true;

  qt.platformTheme = "gtk3";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

  gtk.iconTheme.package = gruvboxplus;
  gtk.iconTheme.name = "GruvboxPlus";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
