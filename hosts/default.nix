{
  inputs,
  system,
}: let
  specialArgs = {inherit inputs system;};
  conf = module:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs system;
      modules = [module ./modules];
    };
in {
  "halite" = conf ./halite;
  "graphite" = conf ./graphite;
  "fluorite" = conf ./fluorite;
  "live" = conf ./live;
}
