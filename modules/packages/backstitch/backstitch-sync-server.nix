{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.backstitch-sync-server = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
      pname = "backstitch-sync-server";
      version = "1.0.0";
      
      src = pkgs.fetchFromGitHub {
        owner = "inkandswitch";
        repo = "backstitch-sync-server";
        tag = "v${finalAttrs.version}";
        hash = "sha256-rpnT3rugbHtKpFdo9A6zfs0sqTqReDjDx53RWTfYb3A=";
      };

      # Replace upstream's stale/incomplete lock file before Nix validates/vendors.
      postPatch = ''
        cp ${./Cargo.lock} Cargo.lock
      '';

      cargoLock = {
        lockFile = ./Cargo.lock;
        allowBuiltinFetchGit = true;
      };

      meta = {
        description = "Real-Time Version Control for Godot";
        homepage = "https://backstitch.dev";
        mainProgram = "server";
      };
    });
  };

  flake.nixosModules.backstitch-sync-server = {config, lib, pkgs, ...}: let
    cfg = config.services.backstitch-sync-server;
  in {
    options.services.backstitch-sync-server = {
      enable = lib.mkEnableOption "backstitch-sync-server";
      package = lib.mkOption {
        type = lib.types.package;
        default = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.backstitch-sync-server;
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8085;
      };
      httpPort = lib.mkOption {
        type = lib.types.int;
        default = 3000;
      };
    };

    config = lib.mkIf cfg.enable {
      systemd.services.backstitch-sync-server = {
        description = "backstitch-sync-server - Real-Time Version Control for Godot";

        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        script = ''
          export DATA_DIR="/var/lib/backstitch"
          export PORT=${toString cfg.port}
          export HTTP_PORT=${toString cfg.httpPort}
          ${lib.getExe cfg.package}
        '';

        serviceConfig = {
          Type = "simple";

          StateDirectory = "backstitch";
          WorkingDirectory = "/var/lib/backstitch";
          StateDirectoryMode = "0700";
          RuntimeDirectory = "backstitch";
          RuntimeDirectoryMode = "0700";

          DynamicUser = true;
          ProtectHome = true;
          Restart = "on-failure";
        };
      };
    };
  };
}
