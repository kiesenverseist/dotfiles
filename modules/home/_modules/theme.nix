{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.evergarden.homeManagerModules.default
  ];

  options = {
    theme.enable = lib.mkEnableOption "enables stylix themeing";
  };

  config = lib.mkIf config.theme.enable {
    evergarden = {
      enable = true;
      variant = "winter";
      accent = "green";
      cache.enable = true;
    };

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

    # evergarden-winter
    stylix.base16Scheme = {
      base00 = "#171c1f"; #base00: "#202020"
      base01 = "#191e21"; #base01: "#2a2827"
      base02 = "#1e2528"; #base02: "#504945"
      base03 = "#262f33"; #base03: "#5a524c"
      base04 = "#839e9a"; #base04: "#bdae93"
      base05 = "#96b4aa"; #base05: "#ddc7a1"
      base06 = "#adc9bc"; #base06: "#ebdbb2"
      base07 = "#f8f9e8"; #base07: "#fbf1c7"
      base08 = "#f57f82"; #base08: "#ea6962"
      base09 = "#f7a182"; #base09: "#e78a4e"
      base0A = "#f5d098"; #base0A: "#d8a657"
      base0B = "#cae0a7"; #base0B: "#a9b665"
      base0C = "#addeb9"; #base0C: "#89b482"
      base0D = "#b2cfed"; #base0D: "#7daea3"
      base0E = "#d2bdf3"; #base0E: "#d3869b"
      base0F = "#f3c0e5"; #base0F: "#bd6f3e"
    };

    # stylix.base16Scheme = let
    #   pkg = pkgs.fetchFromGitea {
    #     domain = "codeberg.org";
    #     owner = "evergarden";
    #     repo = "base16";
    #     rev = "main";
    #     hash = "sha256-R3P/b6Tqbn88KMr8+k8JwqVI9n/Z390dzI2BXPj2gMs=";
    #   };
    # in "${pkg}/themes/evergarden-fall.yaml";

    # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

    stylix.image = ../../../Pictures/wallpapers/solar-system.jpg;

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
      gtk.enable = false;
      fzf.enable = false;
      bat.enable = false;
      dank-material-shell.enable = false;
    };

    stylix.icons = {
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

    # programs.kitty.themeFile = "GruvboxMaterialDarkHard";
    # programs.kitty.themeFile = "flexoki_dark";

    qt.enable = lib.mkDefault true;
    gtk.enable = lib.mkDefault true;
    gtk.gtk4.theme = null;

    # xdg.configFile.kdeglobals.source = let
    #   themePackage = builtins.head (
    #     builtins.filter (
    #       p: builtins.match ".*stylix-kde-theme.*" (builtins.baseNameOf p) != null
    #     )
    #     config.home.packages
    #   );
    #   colorSchemeSlug = lib.concatStrings (
    #     lib.filter lib.isString (builtins.split "[^a-zA-Z]" config.lib.stylix.colors.scheme)
    #   );
    # in "${themePackage}/share/color-schemes/${colorSchemeSlug}.colors";
  };
}
