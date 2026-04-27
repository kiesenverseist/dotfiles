{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  options = {
    dms.enable = lib.mkEnableOption "enables dank material shell";
  };

  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
  ];

  config = lib.mkIf config.dms.enable {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;

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

      plugins = {
        hyprlandSubmap.enable = true;
        homeAssistantMonitor.enable = true;
        dankKDEConnect.enable = true;
        prayerTimes.enable = true;
        flatpakUpdates.enable = true;
        dankBitwarden.enable = true;
        dankPomodoroTimer.enable = true;
        dankBatteryAlerts.enable = true;
        dankHyprlandWindows.enable = true;
        dankDesktopWeather.enable = true;
      };
    };

    services.swaync.enable = false;
    services.swayosd.enable = false;

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
