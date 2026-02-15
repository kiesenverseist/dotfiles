{pkgs, ...}: {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    # ./which-key.nix
  ];

  wayland.windowManager.hyprland = {
    settings = {
      source = [
        "~/.config/hypr/main.conf"
        "~/.config/hypr/monitors.conf"
      ];

      # bind = [
      #   "SUPER, grave, overview:toggle,"
      # ];

      # smart gaps from wiki
      workspace = [
        "w[tv1]s[false], gapsout:0, gapsin:0"
        "f[1]s[false], gapsout:0, gapsin:0"
      ];
      windowrule = [
        "border_size 0, rounding 0, match:float 0, match:workspace w[tv1]s[false]"
        "border_size 0, rounding 0, match:float 0, match:workspace f[1]s[false]"
      ];

      exec-once = [
        "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
      ];
    };

    plugins = [
      # pkgs.hyprlandPlugins.hyprspace
      # pkgs.hyprlandPlugins.hyprbars
    ];
  };
}
