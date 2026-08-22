{
  clan.inventory.instances.import-homebox = {
    module.name = "importer";
    roles.default.machines.halite = {};
    roles.default.extraModules = [
      ({
        config,
        lib,
        pkgs,
        ...
      }: let
        vars = config.clan.core.vars.generators;
      in {
        services.homebox = {
          enable = true;
          settings = {
            HBOX_OPTIONS_TRUST_PROXY = "true";
            HBOX_OPTIONS_ALLOW_LOCAL_LOGIN = "false";
            HBOX_OIDC_ENABLED = "true";
            HBOX_OIDC_ISSUER_URL = "https://idp.ladon-minnow.ts.net";
            HBOX_OIDC_CLIENT_ID = "a32793c95b35fb57bb078c1b51bd52cc";
          };
          secrets = {
            HBOX_AUTH_API_KEY_PEPPER = vars.homebox-api-pepper.files.secret.path;
            HBOX_OIDC_CLIENT_SECRET = vars.homebox-oidc.files.secret.path;
          };
        };

        clan.core.state.homebox.folders = ["/var/lib/homebox"];

        services.caddy.virtualHosts."homebox.kiesen.moe".extraConfig = ''
          reverse_proxy http://[::1]:7745
        '';
        services.caddy.virtualHosts."hb.kiesen.moe".extraConfig = config.services.caddy.virtualHosts."homebox.kiesen.moe".extraConfig;

        clan.core.vars.generators = {
          homebox-api-pepper = {
            files.secret = {};
            runtimeInputs = [pkgs.openssl];
            script = ''
              openssl rand -base64 48 > $out/secret
            '';
          };
          homebox-oidc = {
            prompts.secret = {
              description = "The oidc secret for homebox";
              persist = true;
            };
          };
        };
      })
    ];
  };
}
