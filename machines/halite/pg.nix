{
  config,
  pkgs,
  lib,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = lib.mkForce pkgs.postgresql_16;
    authentication = ''
      #type	database	DBuser	auth-method
      local	all			all		trust
    '';
  };

  clan.core.vars.generators.pgadmin = {
    prompts.password = {
      description = "Initial password for pgadmin";
      persist = true;
    };
  };

  services.pgadmin = {
    enable = true;
    openFirewall = true;
    initialEmail = "creativeibi77@gmail.com";
    initialPasswordFile = config.clan.core.vars.generators.pgadmin.files.password.path;
  };
}
