{
  _class = "clan.service";
  manifest.name = "harmonia";

  roles.server = {
    perInstance = {...}: {
      nixosModule = {config, ...}: {
        clan.core.vars.generators.harmonia = {
          prompts.name = {
            description = "The name for the key. Typically the domain followed by a number. ex: `cache.my.tld-1`";
            persist = true;
          };
          files.name.secret = false;
          files.secret.secret = true;
          files.pub.secret = false;

          script = ''
            nix-store --generate-binary-cache-key $(cat $prompts/name) $out/secret $out/pub
          '';
        };

        services.harmonia = {
          enable = true;
          signKeyPaths = [config.clan.core.vars.generators.harmonia.files.secret.path];
        };
      };
    };
  };
}
