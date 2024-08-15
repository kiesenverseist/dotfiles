{ lib, ... }:

{

  services.hypridle = {
    # enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
        ignore_dbus_inhibit = false;
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 300;                                 # 5min
          on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on & sleep 1 && eww close-all && eww open bar1";
        }
      ];

    };
  };
  
  programs.hyprlock = {
    # enable = true;
    extraConfig = ''
general {
  grace = 100
}

background {
  monitor = 
  path = screenshot
  
  blur_passes = 3
  blur_size = 7
  noise = 0.0117
  contrast = 0.8916
  brightness = 0.8172
  vibrancy = 0.1696
  vibrancy_darkness = 0.0

}

input-field {
    monitor =
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = false
    outer_color = rgb(151515)
    inner_color = rgb(200, 200, 200)
    font_color = rgb(10, 10, 10)
    fade_on_empty = true
    placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
    hide_input = false

    position = 0, -20
    halign = center
    valign = center
}

label {
    monitor =
    text = $USER
    color = rgba(200, 200, 200, 1.0)
    font_size = 25
    font_family = Noto Sans

    position = 0, 80
    halign = center
    valign = center
}

label {
    monitor =
    text = $TIME
    color = rgba(200, 200, 200, 1.0)
    font_size = 25
    font_family = Noto Sans

    position = 0, -80
    halign = center
    valign = center
}

    '';
  };

}
