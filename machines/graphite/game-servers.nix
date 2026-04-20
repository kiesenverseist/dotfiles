{
  config,
  # lib,
  pkgs,
  # modulesPath,
  inputs,
  ...
}: let
  factorio-custom = pkgs.callPackage ./factorio-custom {releaseType = "headless";};
in {
  imports = [
    ../../hosts/modules/satisfactory.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
    # inputs.foundryvtt.nixosModules.foundryvtt
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  clan.core.vars.generators.factorio = {
    prompts.password = {
      description = "the password for the factorio game";
    };

    files.settings.secret = true;
    script = ''
      cat << EOF > $out/settings
        {
          "game-password": "$(cat $prompts/password)"
        }
      EOF
    '';
  };

  services.factorio = {
    enable = true;
    lan = true;
    requireUserVerification = false;
    nonBlockingSaving = true;
    saveName = "spaceage-m";
    extraSettingsFile = config.clan.core.vars.generators.factorio.files.settings.path;
    admins = ["kiesenverseist"];
    package = factorio-custom;
  };

  # services.foundryvtt = {
  #   enable = false;
  #   # hostName = "graphite";
  #   minifyStaticFiles = true;
  #   package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12; # Sets the version to the latest FoundryVTT v12.
  #   proxyPort = 443;
  #   proxySSL = true;
  #   upnp = false;
  # };

  services.satisfactory = {
    enable = false;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers = {
      maryam = {
        enable = true;
        autoStart = false;
      };
      gtnh = {
        enable = true;
        package = pkgs.writeShellApplication {
          name = "gtnh-runner";
          text = ''java "$@" -jar lwjgl3ify-forgePatches.jar nogui'';
          runtimeInputs = [pkgs.jdk25];
        };
        autoStart = false;
        jvmOpts = "-Xms6G -Xmx6G -Dfml.readTimeout=180 @java9args.txt";
      };
      kiesens_pack = let 
        inherit (inputs.nix-minecraft.lib) collectFilesAt;
        modpack = pkgs.fetchModrinthModpack {
          url = "https://cdn.modrinth.com/data/aiyZy0Bi/versions/6LY8E7q6/Kiesen%27s%20pack%200.6.0.mrpack";
          packHash = "sha256-7OBTsFrRdok9rs4Hey+PrZykgp73qPyK22MPsAY/vRo=";
          side = "server";
        };

        mods = collectFilesAt modpack "mods";
        symlinks = removeAttrs mods [
          "mods/connector-2.0.0-beta.14+1.21.1-full.jar" 
          "mods/continuity-3.0.0+1.21.neoforge.jar"
          "mods/controlify-3.0.0-beta.3+1.21.1-neoforge.jar"
          "mods/BetterGrassify-1.7.0+neoforge.1.21.1.jar"
          "mods/distraction_free_recipes-neoforge-1.2.1-1.21.1.jar"
          "mods/ConnectorExtras-1.12.1+1.21.1.jar"
        ];
      in {
        enable = true;
        package = pkgs.minecraftServers.neoforge-1_21_1-21_1_227;
        autoStart = false;
        jvmOpts = "-Xms6G -Xmx6G";
        inherit symlinks;
      };
    };
  };
}
