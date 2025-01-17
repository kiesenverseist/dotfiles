{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../cachix.nix
    # inputs.sops-nix.nixosModules.sops
  ];

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
  networking.nameservers = ["9.9.9.9" "1.1.1.1"];

  # networking.bridges.br0.interfaces = ["enp34s0"];

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      theme = "${import ../sddm-theme.nix {inherit pkgs;}}";
    };
    defaultSession = "plasma";
  };

  services.desktopManager.plasma6.enable = true;

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

  services.harmonia = {
    enable = true;
    signKeyPaths = ["/var/lib/secrets/harmonia.secret"];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.direnv.enable = true;

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    FLAKE = "/home/kiesen/.config/system";
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
     "aspnetcore-runtime-6.0.36"
     "aspnetcore-runtime-wrapped-6.0.36"
     "dotnet-sdk-6.0.428"
     "dotnet-sdk-wrapped-6.0.428"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    kiesen = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel" "libvirtd" "media"]; # Enable ‘sudo’ for the user.
    };
    zaky = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["wheel" "libvirtd"]; # Enable ‘sudo’ for the user.
    };
  };

  users.groups = {
    media = {};
  };

  nix.settings.trusted-users = ["root" "@wheel"];

  fonts.packages = with pkgs; [
    # (nerdfonts.override {fonts = ["FiraCode"];})
    nerd-fonts.fira-code
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {extraPkgs = pkgs: with pkgs; [libgdiplus keyutils libkrb5 libpng libpulseaudio libvorbis stdenv.cc.cc.lib xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver];}; # https://github.com/ValveSoftware/gamescope/issues/905
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

    # virt-manager
    polkit-kde-agent
    virtiofsd
  ];

  # flatpak
  services.flatpak.enable = true;

  services.home-assistant = {
    enable = true;
    config = null;
    lovelaceConfig = null;
    extraComponents = [
      "analytics"
      "default_config"
      "esphome"
      "shopping_list"
      "wled"
      "met"
      "radio_browser"
      "google_translate"
      "isal"
      "cloud"
      "network"
      "config"
      "mobile_app"
      "tuya"
      "nanoleaf"
      "octoprint"
      "ipp"
    ];
  };

  services.jellyfin = {
    enable = true;
    group = "media";
  };

  services.plex = {
    enable = true;
    group = "media";
  };

  services.jellyseerr = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
    package = pkgs.sonarr.overrideAttrs (pkgs.lib.const {doCheck = false;});
    group = "media";
  };

  services.radarr = {
    enable = true;
    group = "media";
  };

  services.deluge = {
    enable = true;
    group = "media";
    web.enable = true;
    # web.port = 8000;
  };

  services.komga = {
    enable = true;
    group = "media";
    settings.server.port = 8080;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

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

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  programs.nbd.enable = true;

  services.gitea = {
    enable = true;
    lfs.enable = true;
    settings.server.ROOT_URL = "https://halite.ladon-minnow.ts.net/git/";
  };

  services.gitea-actions-runner = {
    instances."main" = {
      name = "main";
      enable = true;
      url = config.services.gitea.settings.server.ROOT_URL;
      token = "zk0hCo1VHHjdadQPH4X4IbMQ5u09Le7KSuinNyD5";
      labels = [
        "native:host"
        "ubuntu-latest:docker://node:16-bullseye"
        "ubuntu-22.04:docker://node:16-bullseye"
      ];
    };
  };

  # services.qbittorrent = {
  #   enable = true;
  #   user = "kiesen";
  # };

  # sops = {
  #   defaultSopsFile = ../../secrets/secrets.yaml;
  #   defaultSopsFormat = "yaml";
  #
  #   age.keyFile = "/home/kiesen/.config/sops/age/keys.txt";
  #
  #   secrets.cloudflare_tunnel_token.owner = config.services.cloudflared.user;
  # };

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

        route /jellyseerr/* {
          uri strip_prefix /jellyseerr
          reverse_proxy localhost:5055
        }

        redir /jellyfin /jellyfin/
        reverse_proxy /jellyfin/* localhost:8096

        redir /sonarr /sonarr/
        reverse_proxy /sonarr/* localhost:8989

        redir /radarr /radarr/
        reverse_proxy /radarr/* localhost:7878

        redir /komga /komga/
        reverse_proxy /komga/* localhost:8080
      '';
    };
  };

  services.restic.backups = let
    paths = [
      "/etc/group"
      "/etc/machine-id"
      "/etc/NetworkManager/system-connections"
      "/etc/passwd"
      "/etc/subgid"
      "/etc/ssh"
      "/home"
      "/root"
      "/var/lib"
      "/var/lib/plex/Plex Media Server/Preferences.xml"
    ];
    exclude = [
      "/home/*/.cache"
      "/home/*/.steam"
      "/home/*/.local/share/Steam"
      "/var/lib/plex"
    ];
    passwordFile = "/var/lib/secrets/restic-password";
  in {
    local = {
      inherit paths exclude passwordFile;
      initialize = true;
      repository = "/var/backup/restic";
      timerConfig = {
        OnCalendar = "01:05";
        Persistent = true;
        RandomizedDelaySec = "5h";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
    };
    backblaze = {
      inherit paths exclude passwordFile;
      initialize = true;
      repository = "s3:s3.us-east-005.backblazeb2.com/kiesen";
      environmentFile = "/var/lib/secrets/backblaze.env";
      timerConfig = {
        OnCalendar = "02:05";
        Persistent = true;
        RandomizedDelaySec = "5h";
      };
      pruneOpts = [
        "--keep-daily 3"
        "--keep-weekly 3"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
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
