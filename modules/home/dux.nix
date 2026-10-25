{...}: {
  flake-file.inputs = {
    dux = {
      url = "github:duxlabs-dev/dux-shell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dux-plugin-registry = {
      url = "github:duxlabs-dev/dux-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dux-calendar = {
      url = "github:duxlabs-dev/dux-calendar";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.dank-qml-common.follows = "dux/dank-qml-common";
    };

    dux-files = {
      url = "github:duxlabs-dev/dux-files";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.dank-qml-common.follows = "dux/dank-qml-common";
    };
  };

  flake.homeModules.dux = {
    config,
    lib,
    inputs,
    ...
  }: {
    options = {
      dux.enable = lib.mkEnableOption "enables dux shell";
    };

    imports = [
      inputs.dux.homeModules.default
      inputs.dux-plugin-registry.homeModules.default
      inputs.dux-calendar.homeModules.default
      inputs.dux-files.homeModules.default
    ];

    config = lib.mkIf config.dux.enable {
      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;

        enableCalendarEvents = false;

        # settings = lib.mkForce null;
        settings = {};
        # settings = {
        #   barConfigs = [
        #     {
        #       id = "default";
        #       position = 2;
        #     }
        #   ];
        #   useAutoLocation = true;
        #   currentThemeName = "green";
        #   currentThemeCategory = "generic";
        # };

        # plugins = {
        #   # hyprlandSubmap.enable = true;
        #   homeAssistantMonitor.enable = true;
        #   dankKDEConnect.enable = true;
        #   prayerTimes.enable = true;
        #   flatpakUpdates.enable = true;
        #   dankBitwarden.enable = true;
        #   dankPomodoroTimer.enable = true;
        #   # dankBatteryAlerts.enable = true;
        #   dankHyprlandWindows.enable = true;
        #   dankDesktopWeather.enable = true;
        # };
      };

      programs.dank-calendar = {
        enable = true;
        systemd.enable = true;
      };

      programs.dux-files = {
        enable = true;
        systemd.enable = true;
        portal = {
          enable = true;
          preferred = true;
        };
      };

      services.swaync.enable = false;
      services.swayosd.enable = false;

      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
