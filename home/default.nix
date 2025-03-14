{
  inputs,
  pkgs,
}: let
  extraSpecialArgs = {inherit inputs;};
  conf = attrs:
    inputs.home-manager.lib.homeManagerConfiguration (
      {inherit pkgs extraSpecialArgs;} // attrs
    );
  commonModules = [inputs.stylix.homeManagerModules.stylix ./modules];
in {
  "kiesen@halite" = conf {
    modules = [./home-halite.nix] ++ commonModules;

    extraSpecialArgs =
      extraSpecialArgs // {nix-gaming = inputs.nix-gaming;};
  };
  "kiesen@graphite" = conf {
    modules = [./home-graphite.nix] ++ commonModules;
  };
  "kiesen@kiesen-eos-laptop" = conf {
    modules = [./home-laptop.nix] ++ commonModules;
  };
  "kiesen@fluorite" = conf {
    modules = [./home-fluorite.nix] ++ commonModules;
  };
  "ibrahim.fuad@au-lap-0618.saberastronautics.net" = conf {
    modules = [./work-laptop.nix] ++ commonModules;
  };
  "ibrahim.fuad@graphite" = conf {
    modules = [./work-graphite.nix] ++ commonModules;
  };
}
