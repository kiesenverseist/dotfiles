{...}: {

  services.hypridle = {
    # enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        ignore_dbus_inhibit = false;
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          # on-resume = "hyprctl dispatch dpms on & sleep 1 && eww close-all && eww open bar1";
          on-resume = "hyprctl dispatch dpms on & sleep 1";
        }
      ];
    };
  };
}
