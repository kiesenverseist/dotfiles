{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options = {
    guiMinimal.enable = lib.mkEnableOption "enables basic gui config";
  };

  config = lib.mkIf config.guiMinimal.enable {
    # nixgl config
    nixGL = {
      packages = lib.mkDefault inputs.nixgl.packages;
    };

    home.packages = with pkgs; [
      fira-code
      gohufont
      nerd-fonts.fira-code
      nerd-fonts.gohufont
      nerd-fonts.symbols-only

      (config.lib.nixGL.wrap neovide)
      floorp
      obsidian
      todoist-electron
      # hyprpanel

      wl-clipboard
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["FiraCode Nerd Font Mono" "Symbols Nerd Font Mono"];
        sansSerif = ["FiraCode Nerd Font" "Symbols Nerd Font"];
      };
    };

    home.sessionVariables = {
      TERMINAL = "kitty";
      TERMCMD = "kitty";
    };

    programs.kitty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.kitty;
      font = {
        # name = "FiraCode Nerd Font";
        name = "FiraCode Mono,Symbols Nerd Font";
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
      package = pkgs.rofi-wayland;
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
      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-power-menu
      ];
    };
  };
}
