# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./game-servers.nix
    ./logiops.nix
    ../../hosts/modules
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    inputs.home-manager.nixosModules.default
  ];

  # boot.kernelPackages = pkgs.linuxPackages_testing;

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
  boot.loader.systemd-boot.configurationLimit = 20;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "graphite"; # Define your hostname.

  networking.useDHCP = false;
  networking.bridges."br0".interfaces = ["eno2"];
  networking.interfaces."br0".useDHCP = true;

  # Select internationalisation properties.
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  services.displayManager.sddm = {
    enable = true;
    #   wayland.enable = true;
    theme = "${pkgs.sddm-sugar-dark}";
  };
  services.displayManager.defaultSession = "hyprland";
  services.xserver = {
    enable = true;
    # desktopManager.plasma5.enable = true;
    videoDrivers = ["amdgpu"];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.publish = {
    addresses = true;
    domain = true;
    userServices = true;
    workstation = true;
  };

  # services.onedrive.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;

    extraConfig.pipewire-pulse."30-network-publish" = {
      "pulse.cmd" = [
        {
          cmd = "load-module";
          args = "module-native-protocol-tcp";
        }
        {
          cmd = "load-module";
          args = "module-zeroconf-publish";
        }
      ];
      "pulse.properties" = [
        {
          server.address = [
            "unix:native"
            "tcp:0.0.0.0:4713"
          ];
        }
      ];
    };
  };

  services.samba = {
    enable = true;
    settings.global = {
      "client min protocol" = "smb2";
    };
  };

  services.blueman.enable = true;

  programs.hyprland.enable = true;

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
  services.joycond.enable = true;

  # vr
  services.monado.enable = false;
  services.wivrn.enable = true;

  programs.alvr.enable = false;

  programs.obs-studio = {
    enable = true;
    # enableVirtualCamera = true;
    plugins = [
      pkgs.obs-studio-plugins.wlrobs
      pkgs.obs-studio-plugins.obs-backgroundremoval
      # input-overlay requires x11 which i don't use.
      # pkgs.obs-studio-plugins.input-overlay
    ];
  };

  programs.wshowkeys.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";

    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    VDPAU_DRIVER = "radeonsi";
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        libvdpau-va-gl
        libva-vdpau-driver
      ];
    };

    steam-hardware.enable = true;

    keyboard.qmk.enable = true;

    bluetooth.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiesen = {
    extraGroups = ["wheel" "libvirtd" "qemu-libvirtd" "disk" "adbusers" "dialout"];
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          libconfig
          openssl
          libgdiplus
          keyutils
          libkrb5
          libpng
          libpulseaudio
          libvorbis
          fuse
          stdenv.cc.cc.lib
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libsForQt5.qt5.qtbase
          libsForQt5.qt5.qtmultimedia
          nss
        ];
    }; # https://github.com/ValveSoftware/gamescope/issues/905
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nixd

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    virt-manager
    kdePackages.polkit-kde-agent-1
    virtiofsd

    inputs.nixpkgs-xr.packages.x86_64-linux.wayvr-dashboard
    wlx-overlay-s
    jamesdsp
  ];

  # List services that you want to enable:

  # services.weechat.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  nixpkgs.config.rocmSupport = false;
  services.ollama = {
    enable = false;
    host = "0.0.0.0";
    rocmOverrideGfx = "11.0.1";
  };
  services.open-webui = {
    enable = false;
    host = "0.0.0.0";
    environment.OLLAMA_API_BASE_URL = "http://localhost:${builtins.toString config.services.ollama.port}";
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
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;
    # sharedDirectories = {
    #   my-share = {
    #     source = "/home/kiesen/old-ssd/shared";
    #     target = "shared";
    #   };
    # };
    docker.enable = true;
  };



  # systemd.user.tmpfiles.rules = ["f /dev/shm/looking-glass 0666 root qemu-libvirtd -"];

  systemd.tmpfiles.settings = {
    "looking-glass-mem" = {
      "/dev/shm/"."looking-glass" = {
        group = "qemu-libvirtd";
        user = "root";
        mode = "0765";
      };
    };
  };

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

  '';

  # enable core dumps
  systemd.coredump.enable = true;

  programs.nbd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
