{inputs, ...}: {
  imports = [inputs.clan-core.flakeModules.default];

  clan = {
    inventory = {
      meta = {
        name = "kiesnet";
      };

      machines = {
        lazurite = {
          deploy = {
            targetHost = "lazurite";
            buildHost = "kiesen@graphite";
          };
        };
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
