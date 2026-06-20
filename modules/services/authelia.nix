{
  clan.inventory.instances.import-authelia = {
    module.name = "importer";
    roles.default.machines.halite = {};
    roles.default.extraModules = [
      ({
        config,
        pkgs,
        ...
      }: let
        vars = config.clan.core.vars.generators;

        domain = "auth.kiesen.moe";
      in {
        services.authelia.instances.main = {
          enable = true;
          settings = {
            theme = "auto";
            log.level = "info";
            server.address = "tcp://:9091/";
            session.cookies = [
              {
                domain = "kiesen.moe";
                authelia_url = "https://${domain}";
              }
            ];
            access_control = {
              default_policy = "deny";
              rules = [
                {
                  inherit domain;
                  policy = "bypass";
                }
                {
                  domain = "*.kiesen.moe";
                  policy = "one_factor";
                }
              ];
            };
            storage.local.path = "/var/lib/authelia-main/db.sqlite";
            notifier.filesystem.filename = "/var/lib/authelia-main/notifications.yml";
            authentication_backend.file.path = "/etc/authelia/users.yml";
          };
          secrets = {
            jwtSecretFile = vars.authelia-jwt.files.secret.path;
            storageEncryptionKeyFile = vars.authelia-encryption.files.secret.path;
          };
        };

        environment.etc."authelia/users.yml" = {
          mode = "0400";
          user = "authelia-main";
          text = ''
            users:
              kiesen:
                # generate with `authelia -c authelia crypto hash generate`
                password: "$argon2id$v=19$m=65536,t=3,p=4$fQWBaZEdE9H6zxkmTl2AEw$iwB0gtbaDAyhgBKDrYcVeJ9wvzE1LBAXYk9LRh86nU4"
                displayname: "kiesen"
                email: "creativeibi77@gmail.com"
                groups: ["admins"]
          '';
        };

        clan.core.state.authelia.folders = ["/var/lib/authelia-main"];

        services.caddy.virtualHosts.${domain}.extraConfig = ''
          reverse_proxy http://127.0.0.1:9091
        '';

        clan.core.vars.generators = let
          gen = {
            files.secret.owner = "authelia-main";
            runtimeInputs = [pkgs.openssl];
            script = ''openssl rand -base64 32 | tr -d '\n' > "$out"/secret '';
          };
        in {
          authelia-jwt = gen;
          authelia-encryption = gen;
        };
      })
    ];
  };
}
