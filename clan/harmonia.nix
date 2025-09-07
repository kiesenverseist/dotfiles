{
  _class = "clan.service";
  manifest.name = "harmonia";

  roles.server = {
    perInstance = {...}: {
      nixosModule = {
        config,
        pkgs,
        ...
      }: {
        clan.core.vars.generators.harmonia = {
          prompts.name = {
            description = "The name for the key. Typically the domain followed by a number. ex: `cache.my.tld-1`";
            persist = true;
          };
          files.name.secret = false;
          files.secret.secret = true;
          files.pub.secret = false;

          script = ''
            ${pkgs.nix}/bin/nix-store --generate-binary-cache-key $(cat $prompts/name) $out/secret $out/pub
          '';
        };

        services.harmonia = {
          enable = true;
          signKeyPaths = [config.clan.core.vars.generators.harmonia.files.secret.path];
        };
      };
    };
  };

  roles.client = {
    perInstance = {roles, ...}: {
      nixosModule = {config, ...}: let
        server-machines = builtins.attrNames (roles.server.machines or {});
        servers = builtins.foldl' (
          acc: server: let
            key-path = "${config.clan.core.settings.directory}/vars/per-machine/${server}/harmonia/pub/value";
          in
            if builtins.pathExists key-path
            then acc // {"http://${server}:5000" = builtins.readFile key-path;}
            else acc
        ) {} 
        server-machines;
      in {
        nix.settings = {
          substituters = builtins.attrNames servers;
          trusted-public-keys = builtins.attrValues servers;
        };
      };
    };
  };
}
