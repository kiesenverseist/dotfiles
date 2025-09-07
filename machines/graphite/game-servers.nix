{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
  factorio-custom = pkgs.callPackage ./factorio-custom {releaseType = "headless";};
in {
  imports = [
    ../../hosts/modules/satisfactory.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    # inputs.foundryvtt.nixosModules.foundryvtt
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  services.factorio = {
    enable = true;
    lan = true;
    requireUserVerification = false;
    nonBlockingSaving = true;
    saveName = "spaceage-m";
    game-password = "apple";
    admins = ["kiesenverseist"];
    package = factorio-custom;
  };

  # services.foundryvtt = {
  #   enable = false;
  #   # hostName = "graphite";
  #   minifyStaticFiles = true;
  #   package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12; # Sets the version to the latest FoundryVTT v12.
  #   proxyPort = 443;
  #   proxySSL = true;
  #   upnp = false;
  # };

  services.satisfactory = {
    enable = false;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      maryam = {
        enable = true;
      };
    };
  };

}
