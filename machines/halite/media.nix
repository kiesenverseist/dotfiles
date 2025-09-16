{
  config,
  pkgs,
  lib,
  ...
}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    kiesen = {
      extraGroups = ["media"]; # Enable ‘sudo’ for the user.
    };
  };

  users.groups = {
    media = {};
  };

  services.jellyfin = {
    enable = true;
    group = "media";
  };

  services.plex = {
    # enable = true;
    group = "media";
  };

  services.jellyseerr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
    package = pkgs.sonarr.overrideAttrs (pkgs.lib.const {doCheck = false;});
    group = "media";
  };

  services.radarr = {
    enable = true;
    group = "media";
  };

  services.deluge = {
    enable = true;
    group = "media";
    web.enable = true;
    # web.port = 8000;
  };

  services.komga = {
    enable = true;
    group = "media";
    settings.server.port = 8084;
  };

  # services.qbittorrent = {
  #   enable = true;
  #   user = "kiesen";
  # };

  services.immich = {
    enable = true;
    accelerationDevices = null;
  };
  users.users.immich.extraGroups = ["video" "render"];

  services.samba = {
    enable = true;
    # package = pkgs.samba4Full;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        # "min protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # "hosts allow" = "192.168.1. 127.0.0.1 localhost";
        # "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "media" = {
        "path" = "/var/media";
        "browsable" = "yes";
        "writable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "media";
        "force group" = "media";
      };
    };
  };

  users.users.media = {
    description = "write access to the media samba share";
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      userServices = true;
      workstation = true;
    };
  };

  clan.core.vars.generators.user-password-media.files.user-password.deploy = lib.mkForce true;

  system.activationScripts = {
    init_smbpasswd.text = let
      passwordFile = config.clan.core.vars.generators.user-password-media.files.user-password.path;
    in ''
      /run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${passwordFile})\n$(/run/current-system/sw/bin/cat ${passwordFile})\n" | /run/current-system/sw/bin/smbpasswd -sa media
    '';
  };
}
