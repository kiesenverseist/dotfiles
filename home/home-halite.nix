{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./modules
  ];

  guiMinimal.enable = true;
  programming.enable = true;
  # de.enable = false;

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
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # cli stuff
    nvtopPackages.full
    lf
    ctpv

    # proprietary stuffs
    vesktop

    # gaming
    looking-glass-client

    libva
    vaapiVdpau
    libvdpau-va-gl
    #nvapi latencyflex

    inputs.nix-alien.packages.${system}.nix-alien
  ];

  # programs.hyprlock.enable = true;
  # services.hypridle.enable = true;

  xdg.systemDirs.data = [
    "var/lib/flatpak/exports/share"
    "/home/kiesen/.local/share/flatpak/exports/share"
  ];

  ## CLI Tools
  programs.git = {
    userName = "Ibrahim Fuad";
    userEmail = "creativeibi77@gmail.com";
  };

  services.swayosd = {enable = true;};

  programs.mangohud = {
    enable = true;
  };

  # remember to do the manual setup of this on first setup on computer
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  services.udiskie.enable = true;

  services.network-manager-applet.enable = true;

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = ["graphical-session-pre.target"];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
