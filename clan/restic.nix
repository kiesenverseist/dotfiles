{
  _class = "clan.service";
  manifest.name = "restic";

  roles.default = {
    perInstance = {...}: {
      nixosModule = {config, lib, ...}: {
        clan.core.vars.generators = {
          restic = {
            share = true;
            prompts.password = {
              description = "The password for the restic repository";
              persist = true;
              display.group = "restic";
            };
          };

          restic-backblaze = {
            share = true;

            prompts.repository = {
              description = "The for the restic repository";
              persist = true;
              display.group = "restic";
            };
            files.repository.secret = false;

            prompts = {
              aws_access_key_id = {
                description = "s3 key id";
                persist = true;
                display.group = "restic";
              };
              aws_secret_access_key = {
                description = "s3 key secret";
                persist = true;
                display.group = "restic";
              };
            };

            files.env.secret = true;
            script = ''
              cat << EOF > $out/env
                AWS_ACCESS_KEY_ID=$(cat $prompts/aws_access_key_id)
                AWS_SECRET_ACCESS_KEY=$(cat $prompts/aws_secret_access_key)
              EOF
            '';
          };
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
          vars = config.clan.core.vars.generators;
          passwordFile = vars.restic.files.password.path;
        in {
          local = lib.mkIf true {
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
          backblaze = lib.mkIf true {
            inherit paths exclude passwordFile;
            initialize = true;
            repository = vars.restic-backblaze.files.repository.value;
            environmentFile = vars.restic-backblaze.files.env.path;
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
    };
  };
}
