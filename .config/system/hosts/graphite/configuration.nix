# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, lib, pkgs, system, ... }:
let
  factorio-custom = pkgs.callPackage ./factorio-custom {releaseType="headless";};
in 
{
  imports =
  # let
  #   logiops = builtins.fetchTarball {
  #     url = "https://github.com/ckiee/nixpkgs/archive/refs/heads/logiops-nixos.tar.gz";
  #   };
  # in
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../cachix.nix
    # (import "${logiops}/nixos/modules/hardware/logiops")
  ];

  boot.kernelPackages = pkgs.linuxPackages_testing;

  # services.logiops.enable = true;

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 100;

  networking.hostName = "graphite"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.nameservers = [ "9.9.9.9" "1.1.1.1" ];

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      theme = "${import ../sddm-theme.nix {inherit pkgs;}}";
    };
    desktopManager.plasma5.enable = true;
    # displayManager.defaultSession = "plasmawayland";
  };
  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # networking
  # services.create_ap = {
  #   enable = false;
  #   settings = {
  #     INTERNET_IFACE = "enp34s0";
  #     WIFI_IFACE = "wlo1";
  #     SSID = "kiesen-ap";
  #     PASSPHRASE = "apple100";
  #     # WPA_PAIRWISE = "CCMP";
  #   };
  # };

  # services.onedrive.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.polkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    # xwayland.enable = true;
    # xwayland.hidpi = true;
  };

  programs.adb.enable = true;

  systemd.targets.hyprland-session = {
    description = "Hyprland compositor session";
    documentation = ["man:systemd.special(7)"];
    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
   };

  services.xserver.videoDrivers = ["nvidia"];

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };

  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          libconfig
          openssl
        ]);
      });
    })
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      # vgpu = {
      #   enable = true;
      #   unlock.enable = true;
      #   fastapi-dls = {
      #     enable = true;
      #     local_ipv4 = "localhost";
      #     timezone = "Australia/Sydney";
      #   };
      # };
    };

    steam-hardware.enable = true;
    # bluetooth.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiesen = {
    isNormalUser = true;
    # shell = pkgs.defaultzsh;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "libvirtd" "adbusers"]; # Enable ‘sudo’ for the user.
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = [ "FiraCode" ]; })
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    pr167388 = import (fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/d88cd9ff3050bfc7d9382502cd261364e9602f1.tar.gz";
          sha256 = "0przcgr431xlbcnbyjj20bg50qczyq546aq82dknlv59mmx9kx58";
        })
      {config = config.nixpkgs.config;};
    steam = pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ libgdiplus keyutils libkrb5 libpng libpulseaudio libvorbis stdenv.cc.cc.lib xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver ]; }; # https://github.com/ValveSoftware/gamescope/issues/905
  };


  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    wget
    git

    firefox

    pr167388.logiops

    nixd
    home-manager

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    tailscale

    virt-manager
    polkit-kde-agent
    virtiofsd

    # hypr-plugins.hyprbars
  ];

  # pr.logiops.enable = true;

  # flatpak
  services.flatpak.enable = true;

  services.tailscale.enable = true;
  # services.jellyfin.enable = true;
  # services.jellyseerr = {
  #   enable = true;
  # };
  # services.sonarr = {
  #   enable = true;
  # };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.factorio = {
    enable = true;
    requireUserVerification = false;
    nonBlockingSaving = true;
    package = factorio-custom;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  # virtualisation.sharedDirectories = {
  #   my-share = {
  #     source = "/home/kiesen/old-ssd/shared";
  #     target = "shared";
  #   };
  # };

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  programs.nbd.enable = true;

  # services.gitea = {
  #   enable = true;
  #   lfs.enable = true;
  # };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

