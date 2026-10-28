{...}: {
  clan.inventory.instances.import-httpboot = {
    module.name = "importer";
    roles.default.machines.halite = {};
    roles.default.extraModules = [
      ({...}: {
        services.caddy.virtualHosts."http://192.168.1.53".extraConfig = ''
          root * /srv/httpboot
          file_server
        '';

        systemd.tmpfiles.settings.spindle-nixos-image = {
          "/srv/httpboot"."d" = {};
        };
      })
    ];
  };
}
