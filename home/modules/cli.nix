{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    cli.enable = lib.mkEnableOption "enables basic cli config";
  };

  config = lib.mkIf config.cli.enable {
    # sops = {
    #   age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    #   age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    #   age.generateKey = true;
    #
    #   secrets.nix_access_tokens = {
    #     sopsFile = ../../secrets/secrets.yaml;
    #   };
    # };

    nix = {
      package = pkgs.nix;
      settings.experimental-features = ["nix-command" "flakes"];
      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      # extraOptions = ''
      #   !include ${config.sops.secrets.nix_access_tokens.path}
      # '';
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    home.packages = with pkgs; [
      ## cli stuff
      curl
      bc
      atool
      # lf
      # ctpv
      socat
      jq
      unzip
      zstd

      neovim
      neovim-remote
      yadm
      lazygit
      jjui
      isd

      ## nix stuff
      config.nix.package
      nixd
      nh
      nix-output-monitor

      (writeShellApplication {
        name = "nvr-wait";
        runtimeInputs = [neovim-remote];
        text = ''
          nvr -cc vsplit +"setlocal bufhidden=delete" --remote-wait "$@"
        '';
      })
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      PATH = "$HOME/.nix-profile/bin:$HOME/.local/bin:$PATH";
      NH_FLAKE = "$HOME/dotfiles";
      SHELL = "fish";
    };

    # home.file.".config/nixpkgs/config.nix".text = ''
    #   { allowUnfree = true; }
    # '';

    home.file = let
      dotfiles = "${config.home.homeDirectory}/dotfiles";
      sym = dir: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/${dir}";
    in {
      ".config/nvim".source = sym "nvim";
    };

    xdg.userDirs.enable = true;

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
        icat.body = "kitten icat $argv[1]";
        kssh.body = "kitten ssh $argv";
        # starship_transient_rprompt_func.body = "starship module time";
      };
      interactiveShellInit = ''
        zoxide init fish --cmd=cd | source
        fish_hybrid_key_bindings
        if test -n "$NVIM"
          alias nvim="nvr"
          set -gx EDITOR "nvr-wait"
        end
      '';
      plugins = [
        {
          name = "gruvbox";
          src = pkgs.fishPlugins.gruvbox.src;
        }
      ];
    };

    programs.bash.enable = lib.mkDefault true;

    programs.nushell.enable = lib.mkDefault true;

    programs.starship = {
      enable = true;
      enableTransience = true;
      # settings = {
      #   right_format = "$time";
      # };
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = false; # because I manually set this up
    };

    programs.ripgrep = {enable = true;};
    programs.fd = {enable = true;};

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      git = true;
      icons = "auto";
    };

    programs.bat.enable = true;

    programs.git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      ignores = [
        "Session.vim"
      ];
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        user.name = config.programs.git.userName;
        user.email = config.programs.git.userEmail;
        # ui.diff-editor = ["nvr" "-s" "-c" "DiffEditor $left $right $output"];

        # merge-tools.nvr.merge-args = config.programs.jujutsu.settings.ui.diff-editor;
      };
    };

    programs.fzf = {
      enable = true;
    };

    programs.nix-index.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
