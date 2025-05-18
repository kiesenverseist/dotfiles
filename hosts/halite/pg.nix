{config, pkgs, ...}: {

  services.postgresql = {
    enable = true;
	authentication = pkgs.lib.mkOverride 10 ''
	  #type	database	DBuser	auth-method
	  local	all			all		trust
	'';
  };

  services.pgadmin = {
    enable = true;
	openFirewall = true;
	initialEmail = "creativeibi77@gmail.com";
	initialPasswordFile = config.sops.secrets."pgadminPassword".path;
  };

  sops.secrets."pgadminPassword" = {
    sopsFile = ../../secrets/halite.yaml;
  };
}
