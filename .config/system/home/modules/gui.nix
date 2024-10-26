{
  pkgs,
  lib,
  config,
  ...
}: let
  nixGL = import ../packages/nixgl.nix {inherit pkgs config;};
in {
  options = {
    guiMinimal.enable = lib.mkEnableOption "enables basic cli config";

    nixGLPrefix = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Will be prepended to commands which require working OpenGL.

        This needs to be set to the right nixGL package on non-NixOS systems.
      '';
    };
  };

  config = lib.mkIf config.guiMinimal.enable {
    home.packages = with pkgs;
      [
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "Gohu"
          ];
        })

        (nixGL neovide)
        floorp
        obsidian
        todoist-electron
      ]
      ++ lib.optional (config.nixGLPrefix != "") pkgs.nixgl.${config.nixGLPrefix};

    fonts.fontconfig.enable = true;

    home.sessionVariables = {
      TERMINAL = "kitty";
    };

    programs.kitty = {
      enable = true;
      package = nixGL pkgs.kitty;
      # theme = "Gruvbox Material Dark Hard";
      # theme = "Flexoki (Dark)";
      # font = {
      #   name = "FiraCode Nerd Font";
      #   size = 16;
      # };
      settings = {
        # background_opacity = "0.95";
        shell = "fish";
      };
      shellIntegration.enableFishIntegration = true;
    };

    programs.rofi = {
      # enable = true;
      cycle = true;
      # font = "FiraCode Nerd Font 16";
      font = lib.mkForce "GohuFont uni11 Nerd Font Propo 22";
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        # "@theme" = "gruvbox-dark-hard";
        element-icon = {
          size = mkLiteral "2.5ch";
        };
      };
      extraConfig = {
        modes = "window,drun,run,ssh";
      };
    };
  };
}
