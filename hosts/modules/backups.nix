{
  config,
  lib,
  ...
}: let
  cfg = config.services.backups;
in {
  options.services.backups = {
    enable = lib.mkEnableOption "Restic";

    local = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable local restic backups.";
      type = lib.types.bool;
    };

    backblaze = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable restic backups to restic.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."restic/password" = {
      sopsFile = ../../secrets/shared.yaml;
    };

    sops.secrets."restic/backblaze" = {
      sopsFile = ../../secrets/shared.yaml;
    };

    services.restic.backups = let
      paths = [
        "/etc/group"
        "/etc/machine-id"
        "/etc/NetworkManager/system-connections"
        "/etc/passwd"
        "/etc/subgid"
        "/etc/ssh"
        "/home"
        "/root"
        "/var/lib"
        "/var/lib/plex/Plex Media Server/Preferences.xml"
      ];
      exclude = [
        "/home/*/.cache"
        "/home/*/.steam"
        "/home/*/.local/share/Steam"
        "/var/lib/plex"
        "/var/lib/private/ollama"
      ];
      passwordFile = config.sops.secrets."restic/password".path;
    in {
      local = lib.mkIf cfg.local {
        inherit paths exclude passwordFile;
        initialize = true;
        repository = "/var/backup/restic";
        timerConfig = {
          OnCalendar = "01:05";
          Persistent = true;
          RandomizedDelaySec = "5h";
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];
      };
      backblaze = lib.mkIf cfg.backblaze {
        inherit paths exclude passwordFile;
        initialize = true;
        repository = "s3:s3.us-east-005.backblazeb2.com/kiesen";
        environmentFile = config.sops.secrets."restic/backblaze".path;
        timerConfig = {
          OnCalendar = "02:05";
          Persistent = true;
          RandomizedDelaySec = "5h";
        };
        pruneOpts = [
          "--keep-daily 3"
          "--keep-weekly 3"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];
      };
    };
  };
}
