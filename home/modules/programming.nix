{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    programming.enable = lib.mkEnableOption "enables programming config";
  };

  config = lib.mkIf config.programming.enable {
    home.packages = with pkgs; [
      # cli tools
      curl
      socat
      jq
      # dirdiff
      pre-commit
      just

      # tui tools
      neovim
      neovim-remote
      lazygit

      # langs
      clang
      nodejs
      go
      tectonic # modern latex compiler
      texlab # latex
      basedpyright # python lsp
      ruff # python formatter
      lua-language-server
      yaml-language-server

      ## nix stuff
      # nix
      devenv
      cachix
      nixd
      nh
      nix-output-monitor
      alejandra
      colmena
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.vscode.profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        jdinhlife.gruvbox
        ms-python.python
        ms-toolsai.jupyter
        ms-vsliveshare.vsliveshare
      ];
    };

    programs.opam.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.gh.enable = true;
  };
}
