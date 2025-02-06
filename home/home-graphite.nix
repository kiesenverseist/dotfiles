{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.anyrun
    ./modules
  ];

  guiMinimal.enable = true;
  programming.enable = true;
  de.enable = true;
  walker.enable = true;

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

    # lmms
    # ardour
    # lmms-nightly
    # distrho # TODO: broke, check.
    cardinal
    vcv-rack
    carla

    # proprietary stuffs
    vesktop
    # (discord.override {
    #   withOpenASAR = false;
    # })
    discord-ptb

    # programming
    gf
    postgresql
    sqlite

    # gaming
    protontricks
    # gaming.proton-ge
    # gaming.osu-stable # TODO: broke, check
    # gaming.osu-lazer-bin # TODO: broke, check
    # gdlauncher
    prismlauncher
    wine
    lutris
    moonlight-qt
    protonup-qt
    # looking-glass-client
    runelite
    modrinth-app
    # bottles
    xivlauncher
    wlx-overlay-s

    libva
    vaapiVdpau
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

    # edl

    inputs.nix-alien.packages.${system}.nix-alien
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.mimeApps.defaultApplications = {
  };

  programs.vscode = {
    enable = true;
  };

  ## CLI Tools

  programs.git = {
    userName = "Ibrahim Fuad";
    userEmail = "creativeibi77@gmail.com";
  };

  # programs.lf = {
  #   enable = true;
  # };

  programs.anyrun = {
    enable = false;
    config = {
      plugins = let
        anyrun-plugins = inputs.anyrun.packages.${pkgs.system};
      in [
        anyrun-plugins.applications
        anyrun-plugins.randr
      ];
      x = {fraction = 0.5;};
      y = {fraction = 0.3;};
      layer = "overlay";
      showResultsImmediately = true;
      closeOnClick = true;
    };
  };

  programs.rofi.enable = true;

  programs.mangohud = {
    enable = true;
  };

  # dconf.settings = {
  #   "org/virt-manager/virt-manager/connections" = {
  #     autoconnect = ["qemu:///system"];
  #     uris = ["qemu:///system"];
  #   };
  # };
}
