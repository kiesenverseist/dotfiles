{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [inputs.stylix.homeModules.stylix];

  options = {
    theme.enable = lib.mkEnableOption "enables stylix themeing";
  };

  config = lib.mkIf config.theme.enable {
    stylix.enable = true;

    # # flexoki
    # stylix.base16Scheme = {
    #   base00 = "#100f0f"; # ----
    #   base01 = "#1c1b1a"; # ---
    #   base02 = "#282726"; # --
    #   base03 = "#343331"; # -
    #   # base04 = "#403e3c"; # +
    #   # base05 = "#575653"; # ++
    #   base04 = "#878580"; # +
    #   base05 = "#cecdc3"; # ++
    #   base06 = "#878580"; # +++
    #   base07 = "#cecdc3"; # ++++
    #   base08 = "#D14D41"; # red
    #   base09 = "#DA702C"; # orange
    #   base0A = "#D0A215"; # yellow
    #   base0B = "#879A39"; # green
    #   base0C = "#3AA99F"; # aqua/cyan
    #   base0D = "#4385BE"; # blue
    #   base0E = "#8B7EC8"; # purple
    #   base0F = "#CE5D97"; # brown/magenta
    # };

    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    stylix.image = ../../Pictures/wallpapers/solar-system.jpg;

    stylix.polarity = "dark";

    stylix.fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
        package = pkgs.nerd-fonts.fira-code;
      };

      sizes = {
        terminal = 16;
        applications = 14;
      };
    };

    stylix.targets = {
      fish.enable = false;
      kitty.enable = false;
      qt.enable = true;
    };

    stylix.iconTheme = {
      enable = true;
      # package = pkgs.zafiro-icons;
      # dark = "Zafiro-icons";
      package = pkgs.gruvbox-plus-icons;
      dark = "Gruvbox-Plus-Dark";
    };

    stylix.targets.vscode.profileNames = ["default"];

    stylix.cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };

    programs.kitty.themeFile = "GruvboxMaterialDarkHard";
    # programs.kitty.themeFile = "flexoki_dark";

    qt.enable = lib.mkDefault true;
    gtk.enable = lib.mkDefault true;

    xdg.configFile.kdeglobals.source = let
      themePackage = builtins.head (
        builtins.filter (
          p: builtins.match ".*stylix-kde-theme.*" (builtins.baseNameOf p) != null
        )
        config.home.packages
      );
      colorSchemeSlug = lib.concatStrings (
        lib.filter lib.isString (builtins.split "[^a-zA-Z]" config.lib.stylix.colors.scheme)
      );
    in "${themePackage}/share/color-schemes/${colorSchemeSlug}.colors";
  };
}
