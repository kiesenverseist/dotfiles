{inputs, ...}: {
  imports = [inputs.clan-core.flakeModules.default];

  clan = {
    inventory = {
      meta = {
        name = "kiesnet";
      };
    };
  };

  perSystem = {inputs', ...}: {
    devenv.shells.default = {
      packages = [
        inputs'.clan-core.packages.clan-cli
      ];
    };
  };
}
