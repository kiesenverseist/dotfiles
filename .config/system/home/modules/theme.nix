{ inputs, pkgs, lib, config, ... }:
{
  options = {
    theme.enable = lib.mkEnableOption "enables stylix themeing";
  };

  config = lib.mkIf config.cli.enable {

    # flexoki
    stylix.base16Scheme = {
      base00 = "100f0f"; # ----
      base01 = "1c1b1a"; # ---
      base02 = "282726"; # --
      base03 = "343331"; # -
      base04 = "403e3c"; # +
      base05 = "575653"; # ++
      base06 = "878580"; # +++
      base07 = "cecdc3"; # ++++
      base08 = "af3029"; # red
      base09 = "bc5215"; # orange
      base0A = "ad8301"; # yellow
      base0B = "66800b"; # green
      base0C = "24837b"; # aqua/cyan
      base0D = "205ea6"; # blue
      base0E = "5e409d"; # purple
      base0F = "a02f6f"; # brown/magenta
    };
    
    stylix.image = "${config.home.homeDirectory}/Pictures/wallpapers/solar-system.jpg";

  };
}
