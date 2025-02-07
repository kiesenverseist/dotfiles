{
  inputs,
  system,
}: let
  specialArgs = {inherit inputs system;};
  conf = module:
    inputs.nixpkgs.lib.nixosSystem {
      inherit specialArgs system;
      modules = [module];
    };
in {
  "halite" = conf ./halite;
  "graphite" = conf ./graphite;
  "live" = conf ./live;
}
