{...}: {
  clan.inventory.instances.cockroachdb = {
    module.input = "self";
    module.name = "@kiesen/cockroachdb";
    roles.default.machines = {
      graphite = {};
      halite = {};
      lazurite = {};
    };
  };

  clan.modules."@kiesen/cockroachdb" = {
    _class = "clan.service";

    manifest = {
      name = "cockroachdb";
      description = "A distributed HA postgres compatible database";
      categories = ["System"];
    };

    roles.default = {
      description = "To include this machine as a node in the database cluster";
      interface = {...}: {
        options = {
        };
      };

      perInstance = {
        roles,
        machine,
        ...
      }: {
        nixosModule = {
          config,
          lib,
          pkgs,
          ...
        }: let
          pkgsUnfree = import pkgs.path {
            inherit (pkgs.stdenv.hostPlatform) system;
            config.allowUnfreePackages = ["cockroachdb"];
          };
        in {
          nixpkgs.config.allowUnfree = true;

          clan.core.vars.generators = {
            cockroachdb-ca = {
              share = true;
              files."ca.crt" = {};
              files."ca.key".deploy = false;
              runtimeInputs = [pkgsUnfree.cockroachdb];
              script = ''
                cockroachdb cert create-ca \
                  --certs-dir="$out" \
                  --ca-key="$out"/ca.key
              '';
            };
            cockroachdb-node = {
              files."ca.crt" = {};
              files."node.crt" = {};
              files."node.key" = {};

              dependencies = ["cockroachdb-ca"];
              runtimeInputs = [pkgsUnfree.cockroachdb];

              script = ''
                cp "$in"/cockroachdb-ca/ca.crt "$out"/ca.crt
                cockroachdb cert create-node \
                  localhost \
                  ${config.networking.hostName} \
                  ${machine.name}.${config.clan.core.settings.domain} \
                  --certs-dir="$out" \
                  --ca-key="$in"/cockroachdb-ca/ca.key
              '';
            };
          };

          services.cockroachdb = {
            enable = true;
            certsDir = "/run/cockroachdb/certs";
            http.port = 8088;
            listen.address = "[::]";
            extraArgs = ["--advertise-addr" "${machine.name}.${config.clan.core.settings.domain}"];
            join = lib.pipe roles.default.machines [
              lib.attrNames
              (map (n: n + ".${config.clan.core.settings.domain}"))
              (lib.join ",")
            ];
            openPorts = true;
          };

          systemd.services.cockroachdb = let
            certs = config.clan.core.vars.generators.cockroachdb-node.files;
            inherit (config.services.cockroachdb) user group;
          in {
            serviceConfig = {
              RuntimeDirectory = "cockroachdb";
              RuntimeDirectoryMode = "0700";
              LoadCredential = [
                "ca.crt:${certs."ca.crt".path}"
                "node.crt:${certs."node.crt".path}"
                "node.key:${certs."node.key".path}"
              ];
              TimeoutStartSec = "5min";
              NotifyAccess = "all";
            };

            preStart = ''
              install -d \
                -m 0700 -o ${user} -g ${group} \
                /run/cockroachdb/certs

              install \
                -m 0644 -o ${user} -g ${group} \
                "$CREDENTIALS_DIRECTORY/ca.crt" \
                /run/cockroachdb/certs/ca.crt

              install \
                -m 0644 -o ${user} -g ${group} \
                "$CREDENTIALS_DIRECTORY/node.crt" \
                /run/cockroachdb/certs/node.crt

              install \
                -m 0600 -o ${user} -g ${group} \
                "$CREDENTIALS_DIRECTORY/node.key" \
                /run/cockroachdb/certs/node.key
            '';
          };
        };
      };
    };
  };
}
