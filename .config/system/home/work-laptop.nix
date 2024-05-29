{ config, pkgs, ... }:
{
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
  home.stateVersion = "23.11"; # Please read the comment before changing.

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
        
    # curl
    lazygit
    unzip
    # bc
    # lf ctpv
    socat jq
    yadm
    xclip
    
    floorp

    # programming
    # cachix
    neovim
    neovide
    # gf
    # clang 
    # unityhub
    # postgresql
    # sqlite
    # pre-commit
    nixd
    nodejs

    # game dev
    # godot_4
    # pixelorama
    
    # making
    # prusa-slicer
    # kicad

    nix
    nixgl.nixGLIntel
    nh
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    PATH = "$HOME/.nix-profile/bin:$PATH";
    FLAKE = "$HOME/.config/system";
  };

  xdg.userDirs.enable = true;

  xdg.mimeApps.defaultApplications = {

  };

  programs.kitty = {
    enable = true;
    theme = "Gruvbox Material Dark Hard";
    font = {
      name = "FiraCode Nerd Font";
      size = 14;
    };
    settings = {
      background_opacity = "0.95";
      shell = "fish";
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
    '';
  };

  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      right_format = "$time";
    };
  };

  # programs.vscode = {
  #   enable =  true;
  #   extensions = with pkgs.vscode-extensions; [
  #     arrterian.nix-env-selector
  #     jdinhlife.gruvbox
  #     ms-python.python
  #     ms-toolsai.jupyter
  #     ms-vsliveshare.vsliveshare
  #   ];
  # };

  programs.pyenv = { enable = true; };

  programs.direnv = { 
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = { 
    enable = true;
    enableFishIntegration = false; # because I manually set this up
  };

  programs.ripgrep = { enable = true; };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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

  # services.swayosd = { enable = true; };

  programs.rofi = {
    enable = true;
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
    extraConfig = {
      modes = "window,drun,run,ssh";
    };
  };

  # qt.enable = true;
  #
  # qt.platformTheme = "gtk";
  # qt.style.name = "adwaita-dark";
  # # qt.style.package = pkgs.adwaita-qt;
  #
  # gtk.enable = true;
  #
  # gtk.cursorTheme.package = pkgs.bibata-cursors;
  # gtk.cursorTheme.name = "Bibata-Modern-Ice";
  #
  # gtk.theme.package = pkgs.adw-gtk3;
  # gtk.theme.name = "adw-gtk3";
  #
  # gtk.iconTheme.package = gruvboxplus;
  # gtk.iconTheme.name = "GruvboxPlus";

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
