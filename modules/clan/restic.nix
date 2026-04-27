{...}: {
  clan.modules."@kiesen/restic" = {
    _class = "clan.service";

    manifest = {
      name = "restic";
      description = "A backup service that targets a local repository, and s3 target";
      categories = ["System"];
    };

    roles.default = {
      interface = {lib, ...}: {
        options = {
          repositories = {
            local = {
              enable = lib.mkEnableOption "Local restic target";
              directory = lib.mkOption {
                type = lib.types.str;
                default = "/var/backup/restic";
              };
            };

            s3 = lib.mkOption {
              type = lib.types.attrsOf (
                lib.types.submodule (
                  {name, ...}: {
                    options = {
                      name = lib.mkOption {
                        type = lib.types.strMatching "^[a-zA-Z0-9._-]+$";
                        default = name;
                        description = "The name of the backup job";
                      };
                      url = lib.mkOption {
                        type = lib.types.str;
                        description = "The url of the s3 compatible object store";
                      };
                    };
                  }
                )
              ); 
              default = {};
              description = ''
                Target s3 compatible object stores. Repositories will be created automatically within these.
              '';
            };
          };

          exclude = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = [ "*.pyc" ];
            default = [ ];
            description = ''
              Directories/Files to exclude from the backup.
              Use * as a wildcard.
            '';
          };
        };
      };

      perInstance = {settings, ...}: {
        nixosModule = {
          config,
          lib,
          pkgs,
          ...
        }: {
          clan.core.vars.generators = {
            restic = {
              share = true;

              prompts.password = {
                description = "The password for the restic repository";
                persist = true;
                display.group = "restic";
              };

              runtimeInputs = [ pkgs.xkcdpass ];
              script = ''
                [ -s "$out"/password ] || xkcdpass -n 4 -d - > "$out"/password
              '';
            };
          } // lib.mapAttrs' (name: s3:  
              lib.nameValuePair "restic-${name}" {
                share = true;

                prompts = {
                  aws_access_key_id = {
                    description = "s3 key id for ${name}";
                    persist = true;
                    display.group = "restic";
                  };
                  aws_secret_access_key = {
                    description = "s3 key secret for ${name}";
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
              }
            ) settings.repositories.s3;


          services.restic.backups = let
            paths = lib.unique (
              lib.flatten (map (state: state.folders) (lib.attrValues config.clan.core.state))
            );
            exclude = settings.exclude;
            passwordFile = vars.restic.files.password.path;
            vars = config.clan.core.vars.generators;
          in {
            local = lib.mkIf settings.repositories.local.enable {
              inherit paths exclude passwordFile;
              initialize = true;
              repository = settings.repositories.local.directory;
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
          } // lib.mapAttrs' (name: opts:  
              lib.nameValuePair name {
                inherit paths exclude passwordFile;
                initialize = true;
                repository = opts.url;
                environmentFile = vars."restic-${name}".files.env.path;
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
              }
            ) settings.repositories.s3;

          clan.core.backups.providers.restic = {
            list = "restic-list";
            create = "restic-create";
            restore = "restic-restore";
          };

          environment.systemPackages = let 
              allDestinations = [] 
                ++ (if settings.repositories.local.enable then ["local"] else [])
                ++ (lib.attrNames settings.repositories.s3);
              inherit (config.networking) hostName;
          in [
            (pkgs.writeShellApplication {
              name = "restic-create";
              runtimeInputs = [ config.systemd.package ];
              text = ''
                ${lib.concatMapStringsSep "\n" (dest: ''
                  systemctl start restic-backups-${dest}
                '') allDestinations}
              '';
            })
            (pkgs.writeShellApplication {
              name = "restic-list";
              runtimeInputs = [ config.systemd.package ];
              text = ''
                (
                ${lib.concatMapStringsSep "\n" (dest: ''
                  /run/current-system/sw/bin/restic-${dest} snapshots --host ${hostName} --json | jq 'map({"name": ("${dest}::" + .short_id + "::" + .time)})'
                '') allDestinations}
                ) | jq -s 'add // []' 
              '';
            })
            (pkgs.writeShellApplication {
              name = "restic-restore";
              runtimeInputs = [ config.systemd.package ];
              text = ''
                IFS=':' read -ra FOLDER <<< "''${FOLDERS-}"
                repo_name=$(echo "$NAME" | awk -F'::' '{print $1}')
                backup_id=$(echo "$NAME" | awk -F'::' '{print $2}')
                if [[ ! -x /run/current-system/sw/bin/restic-"$repo_name" ]]; then
                  echo "restic-$repo_name not found: Backup name is invalid" >&2
                  exit 1
                fi
                INCLUDES=()
                for f in "''${FOLDER[@]}"; do
                  INCLUDES+=(--include "$f")
                done
                /run/current-system/sw/bin/restic-"$repo_name" --host ${hostName} restore "$backup_id" --target / "''${INCLUDES[@]}"
              '';
            })
          ];
        };
      };
    };
  };
}
