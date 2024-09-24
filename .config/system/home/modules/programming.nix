{ pkgs, lib, config, ... }:

{
  options = {
    programming.enable = lib.mkEnableOption "enables programming config";
  };

  config = lib.mkIf config.programming.enable {
    home.packages = with pkgs; [
      curl
      socat 
      jq
      lazygit

      ## programming
      cachix
      neovim
      clang 
      pre-commit
      nodejs
      go
      devenv
      tectonic
      texlab

      ## nix stuff
      # nix
      nixd
      nh
      nix-output-monitor

    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.vscode = {
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        jdinhlife.gruvbox
        ms-python.python
        ms-toolsai.jupyter
        ms-vsliveshare.vsliveshare
      ];
    };

    programs.pyenv = { enable = true; };

    programs.opam.enable = true;

    programs.direnv = { 
      enable = true;
      nix-direnv.enable = true;
    };

    programs.gh.enable = true;
  };
}
