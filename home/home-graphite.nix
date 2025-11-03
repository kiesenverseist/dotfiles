{
  pkgs,
  inputs,
  ...
}: {
  imports = [ ./modules ];

  de.enable = true;

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
    # cli stuff
    lf
    ctpv

    qbittorrent
    via
    chromium
    restic
    # jellyfin-media-player

    # lmms
    # ardour
    # lmms-nightly
    # distrho # TODO: broke, check.
    cardinal
    # vcv-rack
    carla

    # proprietary stuffs
    vesktop
    # (discord.override {
    #   withOpenASAR = false;
    # })
    discord-ptb

    # gaming
    protontricks
    # gaming.proton-ge
    # gaming.osu-stable # TODO: broke, check
    # gaming.osu-lazer-bin # TODO: broke, check
    # gdlauncher
    (pkgs.prismlauncher.override {jdks = [pkgs.jdk21 pkgs.jdk25];})
    wine
    lutris
    moonlight-qt
    protonup-qt
    # looking-glass-client
    runelite
    # modrinth-app
    # bottles
    xivlauncher
    wlx-overlay-s

    libva
    libva-vdpau-driver
    libvdpau-va-gl
    libva-utils
    #nvapi latencyflex
    nvtopPackages.amd

    # game dev
    pixelorama
    # unityhub
    godot_4

    # making
    prusa-slicer
    kicad
    freecad-wayland
    # openscad-unstable

    # edl

    inputs.nix-alien.packages.${system}.nix-alien
  ];

  programs.vscode.enable = true;

  programs.git.settings.user = {
    name = "Ibrahim Fuad";
    email = "creativeibi77@gmail.com";
  };

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        "[workspace special silent] kitty btop"
        "[workspace 7 silent] vesktop"
        "[workspace special:memo silent] obsidian"
        "bash ~/.config/hypr/start-desktop.sh"
      ];
    };
  };

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };
}
