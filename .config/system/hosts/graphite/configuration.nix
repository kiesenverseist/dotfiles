# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, inputs, lib, pkgs, system, ... }:
let
  factorio-custom = pkgs.callPackage ./factorio-custom {releaseType="headless";};
in 
{
  imports =
  [ 
    ./hardware-configuration.nix
    ../cachix.nix
    ./logiops.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_testing;

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

  networking.useDHCP = false;
  networking.bridges."br0".interfaces = ["eno2"];
  networking.interfaces."br0".useDHCP = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

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
    displayManager.defaultSession = "hyprland";
    videoDrivers = ["amdgpu"];
  };
  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # services.onedrive.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.polkit.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.optimise = {
    automatic = true;
    dates = ["3:00"];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.xdph.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  programs.adb.enable = true;

  systemd.targets.hyprland-session = {
    description = "Hyprland compositor session";
    documentation = ["man:systemd.special(7)"];
    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
   };

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };

  programs.alvr.enable = true;

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
    FLAKE = "/home/kiesen/.config/system";
  };

  hardware = {
    opengl = {
      package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa.drivers;
      package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa.drivers;
      enable = true;
      driSupport32Bit = true;
    };

    steam-hardware.enable = true;

    keyboard.qmk.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiesen = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "libvirtd" "qemu-libvirtd" "disk" "adbusers"]; # Enable ‘sudo’ for the user.
  };

  users.users."ibrahim.fuad" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = [ "FiraCode" ]; })
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override { extraPkgs = pkgs: with pkgs; [ libgdiplus keyutils libkrb5 libpng libpulseaudio libvorbis stdenv.cc.cc.lib xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver ]; }; # https://github.com/ValveSoftware/gamescope/issues/905
  };


  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim

    wget
    git

    firefox

    nixd
    home-manager
    nh

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    tailscale

    virt-manager
    polkit-kde-agent
    virtiofsd

    inputs.hypridle.packages.${pkgs.system}.hypridle
    inputs.hyprlock.packages.${pkgs.system}.hyprlock

    # hypr-plugins.hyprbars
  ];


  # List services that you want to enable:

  # flatpak
  services.flatpak.enable = true;

  services.tailscale.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.factorio = {
    enable = true;
    lan = true;
    requireUserVerification = false;
    nonBlockingSaving = true;
    saveName = "save1";
    admins = [ "kiesenverseist" ];
    package = factorio-custom;
  };

  services.foundryvtt = {
    enable = true;
    # hostName = "graphite";
    minifyStaticFiles = true;
    package = inputs.foundryvtt.packages.${pkgs.system}.foundryvtt_12; # Sets the version to the latest FoundryVTT v12.
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;
    # sharedDirectories = {
    #   my-share = {
    #     source = "/home/kiesen/old-ssd/shared";
    #     target = "shared";
    #   };
    # };
  };

  systemd.user.tmpfiles.rules = ["f /dev/shm/looking-glass 0666 root qemu-libvirtd -"];

  services.udev.extraRules = ''
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

  '';


  # enable core dumps
  systemd.coredump.enable = true; 

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  programs.nbd.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true; # incompatible with flakes :(

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

