
{ config, lib, pkgs, modulesPath, inputs, ... }:
let
  factorio-custom = pkgs.callPackage ./factorio-custom {releaseType="headless";};
in 
{
  imports = [ 
    ../modules/satisfactory.nix
  ];

  services.factorio = {
    enable = true;
    lan = true;
    requireUserVerification = false;
    nonBlockingSaving = true;
    saveName = "save1";
    admins = [ "kiesenverseist" ];
    package = factorio-custom;
  };

  services.foundryvtt = {
    enable = false;
    # hostName = "graphite";
    minifyStaticFiles = true;
    package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12; # Sets the version to the latest FoundryVTT v12.
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };

  services.satisfactory = {
    enable = true;
  };

}
