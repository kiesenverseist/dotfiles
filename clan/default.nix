{inputs, ...}: {
  imports = [inputs.clan-core.flakeModules.default];

  clan = {
    specialArgs = {inherit inputs;};

    inventory = {
      meta = { name = "kiesnet"; };

      machines = {
        lazurite = {
          deploy = {
            targetHost = "lazurite";
            buildHost = "kiesen@graphite";
          };
        };
        fluorite = {
          deploy = {targetHost = "fluorite";};
        };
      };

      instances = {
        admin = {
          roles.default.tags.all = {};
          roles.default.settings = {
            allowedKeys = {
              "kiesen" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDjmUayWr1sJxYNqGeqtp6fOTT38n/5iGJudDrgf630M";
            };
          };
        };

        kiesen-user = {
          module.name = "users";

          roles.default.tags.all = {};
          roles.default.settings = {
            user = "kiesen";

            groups = [
              "wheel"
              "networkmanager"
              "video"
              "input"
              "libvirtd"
              "qemu-libvirtd"
              "dialout"
            ];
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
