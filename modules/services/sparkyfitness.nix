{inputs, ...}: {
  flake-file.inputs.sparkyfitness = {
    url = "github:CodeWithCJ/SparkyFitness?ref=refs/tags/v1.9.0";
    # inputs.nixpkgs.follows = "nixpkgs";
  };

  clan.inventory.instances.import-sparkyfitness = {
    module.name = "importer";
    # roles.default.machines.halite = {};
    roles.default.extraModules = [
      ({ config, pkgs, ... }: let
        # inherit (pkgs.stdenv.hostPlatform) system;
        cfg = config.services.sparkyfitness;
        vars = config.clan.core.vars.generators;
      in {
        imports = [inputs.sparkyfitness.nixosModules.sparkyfitness];

        services.sparkyfitness = {
          enable = true;
          port = 3011;
          frontendUrl = "https://sparkyfitness.kiesen.moe";
          environmentFile = vars.sparkyfitness.files.env.path;
          nginx.enable = false;
        };

        services.caddy.virtualHosts."sparkyfitness.kiesen.moe".extraConfig = ''
          root * ${cfg.frontendPackage}

          request_body {
            max_size 10MB
          }

          handle /api/* {
            reverse_proxy http://127.0.0.1:${toString cfg.port}
          }

          handle /health-data {
            rewrite * /api/health-data
            reverse_proxy http://127.0.0.1:${toString cfg.port}
          }

          handle /uploads/* {
            reverse_proxy http://127.0.0.1:${toString cfg.port}
          }

          handle /mcp* {
            reverse_proxy http://127.0.0.1:${toString cfg.port}
          }

          handle /assets/* {
            header Cache-Control "public, max-age=31536000, immutable, no-transform"
            file_server
          }

          handle {
            header Cache-Control "no-cache, no-store, must-revalidate"
            try_files {path} {path}/ /index.html
            file_server
          }
        '';

        clan.core.state.sparkyfitness.folders = [cfg.stateDir];

        clan.core.vars.generators = {
          # sparkyfitness-api-pepper = {
          #   files.secret = {};
          #   runtimeInputs = [pkgs.openssl];
          #   script = ''
          #     openssl rand -base64 48 > $out/secret
          #   '';
          # };
          # sparkyfitness-oidc = {
          #   prompts.secret = {
          #     description = "The oidc secret for sparkyfitness";
          #     persist = true;
          #   };
          # };
          sparkyfitness = {
            # dependencies = ["sparkyfitness-oidc"];
            files.env = {};
            runtimeInputs = [pkgs.openssl];
            script = ''
              cat << EOF > $out/env
                SPARKY_FITNESS_DB_PASSWORD=$(openssl rand -hex 32)
                SPARKY_FITNESS_APP_DB_PASSWORD=$(openssl rand -hex 32)
                SPARKY_FITNESS_API_ENCRYPTION_KEY=$(openssl rand -hex 32)
                BETTER_AUTH_SECRET=$(openssl rand -hex 32)
              EOF
            '';
          };
        };
      })
    ];
  };
}
