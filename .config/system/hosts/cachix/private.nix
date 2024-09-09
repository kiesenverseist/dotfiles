{ lib, config, ... }:
{
  options = {
    private-cache.enable = lib.mkEnableOption "enables private nix binary caches over tailscale";
  };

  config = lib.mkIf config.private-cache.enable {
    nix = {
      settings = {
        substituters = [
          "http://graphite:5000"
          "http://halite:5000"
        ];
        trusted-public-keys = [
          "graphite:FnIo5szy8arpdbZ/2Y5TvXaQvGUxQ5n8ks0csr7G1aI="
          "halite:LNYbnhzlELsnb/V+Hc/KbQJSnIt+rBLvkVdCTyW2gV4="
        ];
      };
    };
  };
}
