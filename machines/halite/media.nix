{pkgs, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

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
    enable = true;
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
    enable = false;
    group = "media";
    settings.server.port = 8080;
  };

  # services.qbittorrent = {
  #   enable = true;
  #   user = "kiesen";
  # };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    accelerationDevices = null;
  };
  users.users.immich.extraGroups = ["video" "render"];

  services.samba = {
    enable = true;
  };
}
