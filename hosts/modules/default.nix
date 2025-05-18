{ lib, config, ... }: {
  imports = [
    ./backups.nix
    ./cachix.nix
  ];

  options.default.enable = lib.mkOption {
    default = true;
    example = false;
    description = "A set of default configs for hosts";
    type = lib.types.bool;
  };

  config = lib.mkIf config.default.enable {
    services.avahi = {
      enable = lib.mkDefault true;
      nssmdns4 = lib.mkDefault true;
    };
  };
}
