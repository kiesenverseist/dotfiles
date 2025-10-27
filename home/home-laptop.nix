{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [./modules];

  de.enable = true;

  # nixgl config
  nixGL = {
    packages = lib.mkForce inputs.nixgl-stable.packages;
    defaultWrapper = "mesa";
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kiesen";
  home.homeDirectory = "/home/kiesen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vesktop
    weechat
  ];

  wayland.windowManager.hyprland = {
    plugins = lib.mkForce [];
    settings = {
      exec-once = ["waybar & blueberry-tray & nm-applet --indicator & wpaperd & hypridle & wluma"];
    };
  };

  programs.vscode = {
    enable = true;
  };

  programs.git.settings.user = {
    name = "Ibrahim Fuad";
    email = "creativeibi77@gmail.com";
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
