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
        fira-code
        gohufont
        nerd-fonts.fira-code
        nerd-fonts.gohufont
        nerd-fonts.symbols-only

        (nixGL neovide)
        floorp
        obsidian
        todoist-electron
      ]
      ++ lib.optional (config.nixGLPrefix != "") pkgs.nixgl.${config.nixGLPrefix};

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["FiraCode Nerd Font Mono" "Symbols Nerd Font Mono"];
        sansSerif = ["FiraCode Nerd Font" "Symbols Nerd Font"];
      };
    };

    home.sessionVariables = {
      TERMINAL = "kitty";
    };

    programs.kitty = {
      enable = true;
      package = nixGL pkgs.kitty;
      # theme = "Gruvbox Material Dark Hard";
      # theme = lib.mkForce "Flexoki (Dark)";
      themeFile = lib.mkForce "flexoki_dark";
      font = {
        name = "FiraCode Nerd Font";
        size = 16;
      };
      settings = {
        # background_opacity = "0.95";
        shell = "fish";
        disable_ligatures = "cursor";
      };
      shellIntegration.enableFishIntegration = true;
    };

    programs.rofi = {
      # enable = true;
      cycle = true;
      # font = "FiraCode Nerd Font 16";
      font = lib.mkForce "GohuFont 11 Nerd Font Propo 22";
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "@theme" = lib.mkForce "gruvbox-dark-hard";
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
