# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, inputs, ... }:

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
    ./qbittorrent.nix
    inputs.sops-nix.nixosModules.sops
  ];

  # services.logiops.enable = true;

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "halite"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.nameservers = [ "9.9.9.9" "1.1.1.1" ];

  # networking.bridges.br0.interfaces = ["enp34s0"];

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
    # desktopManager.plasma5.enable = true;
    # displayManager.defaultSession = "plasmawayland";
  };
  
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
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
  # sound.enable = true;
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
    # enableNvidiaPatches = true;
    # xwayland.enable = true;
    # xwayland.hidpi = true;
  };

  systemd.targets.hyprland-session = {
    description = "Hyprland compositor session";
    documentation = ["man:systemd.special(7)"];
    bindsTo = ["graphical-session.target"];
    wants = ["graphical-session-pre.target"];
    after = ["graphical-session-pre.target"];
   };

  services.xserver.videoDrivers = ["nvidia"];

  # programs.steam.enable = true;
  # programs.gamemode.enable = true;
  # programs.gamescope = {
  #   enable = true;
  #   # capSysNice = true;
  # };

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
  #       extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
  #         libconfig
  #       ]);
  #     });
  #   })
  # ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    FLAKE = "/home/kiesen/.config/system";
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

    bluetooth.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiesen = {
    isNormalUser = true;
    # shell = pkgs.defaultzsh;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "libvirtd" ]; # Enable ‘sudo’ for the user.
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
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    wget
    git

    firefox

    nixd
    home-manager
    nh

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    tailscale

    # virt-manager
    polkit-kde-agent
    virtiofsd

    # hypr-plugins.hyprbars
  ];

  # flatpak
  services.flatpak.enable = true;

  services.jellyfin.enable = true;
  services.plex.enable = true;
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      # runAsRoot = false;
    };
    onBoot = "start";
    onShutdown = "shutdown";
  };

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker.enable = true;

  programs.virt-manager.enable = true;

  networking.useDHCP = false;
  networking.bridges."br0".interfaces = ["enp34s0"];
  networking.interfaces."br0".useDHCP = true;

  # networking.nat = {
  #   enable = true;
  #   internalInterfaces = ["br0"];
  #   externalInterface = "enp34s0";
  # };
  #
  # networking.bridges."br0".interfaces = [];
  # networking.interfaces."br0".ipv4.addresses = [
  #   {address="192.168.122.1"; prefixLength=24;}
  # ];
  #
  # services.kea.dhcp4 = {
  #   enable = true;
  #   settings = {
  #     interfaces-config.interfaces = ["br0"];
  #     lease-database = {
  #       name = "/var/lib/kea/dhcp4.leases";
  #       persist = true;
  #       type = "memfile";
  #     };
  #     subnet4 = [
  #       {
  #         id = 1;
  #         subnet = "192.168.122.0/24";
  #         pools = [
  #           {pool = "192.168.122.100 - 192.168.122.200";}
  #         ];
  #       }
  #     ];
  #     valid-lifetime = 4000;
  #   };
  # };

  # virtualisation.sharedDirectories = {
  #   my-share = {
  #     source = "/home/kiesen/old-ssd/shared";
  #     target = "shared";
  #   };
  # };

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  programs.nbd.enable = true;

  services.gitea = {
    enable = true;
    lfs.enable = true;
    settings.server.ROOT_URL = "https://halite.ladon-minnow.ts.net/git/";
  };

  services.gitea-actions-runner = {
    instances."first" = {
      name = "first";
      enable = true;
      url = "https://halite.ladon-minnow.ts.net/git/";
      token = "zk0hCo1VHHjdadQPH4X4IbMQ5u09Le7KSuinNyD5";
      labels = [
        "native:host"
        "ubuntu-latest:docker://node:16-bullseye"
        "ubuntu-22.04:docker://node:16-bullseye"
        "ubuntu-20.04:docker://node:16-bullseye"
        "ubuntu-18.04:docker://node:16-buster"
      ];
    };
  };

  services.qbittorrent = {
    enable = true;
    user = "kiesen";
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/kiesen/.config/sops/age/keys.txt";

    secrets.cloudflare_tunnel_token.owner = config.services.cloudflared.user;
  };

  services.tailscale = {
    enable = true;
    permitCertUid = "caddy";
  };

  services.caddy = {
    enable = true;
    virtualHosts."halite.ladon-minnow.ts.net" = {
      extraConfig = ''
        route /git/* {
          uri strip_prefix /git
          reverse_proxy localhost:3000
        }

        redir /jellyfin /jellyfin/
        reverse_proxy /jellyfin/* localhost:8096
      '';
    };
    virtualHosts."local-loopback" = {
      extraConfig = ''
        route /git/* {
          uri strip_prefix /git
          reverse_proxy localhost:3000
        }

        redir /jellyfin /jellyfin/
        reverse_proxy /jellyfin/* localhost:8096
      '';
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "halite" = {
        credentialsFile = "${config.sops.secrets.cloudflare_tunnel_token.path}";
        ingress = {
          "*.kiesen.dev" = "halite.ladon-minnow.ts.net";
          "jellyfin.kiesen.dev" = "local-loopback/jellyfin";
        };
        default = "http_status:404";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

