{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hass.nix
    ./game-servers.nix
    ./vfio.nix
    ./pg.nix
    ./hardware-configuration.nix
    ./proxmox.nix
    ./media.nix
    ../../hosts/modules
  ];

  vfio.enable = lib.mkDefault true;
  specialisation."NO_VFIO".configuration = {
    system.nixos.tags = ["without-vfio"];
    vfio.enable = false;
  };

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
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      theme = "${pkgs.sddm-sugar-dark}";
    };
    defaultSession = "plasma";
  };

  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # services.onedrive.enable = true;

  # Enable sound.
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    bluetooth.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox

    nixd

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    # virt-manager
    kdePackages.polkit-kde-agent-1
    virtiofsd
  ];

  # services.gitea = {
  #   enable = true;
  #   lfs.enable = true;
  #   settings.server.ROOT_URL = "https://halite.ladon-minnow.ts.net/git/";
  # };

  # services.gitea-actions-runner = {
  #   instances."main" = {
  #     name = "main";
  #     enable = true;
  #     url = config.services.gitea.settings.server.ROOT_URL;
  #     token = "zk0hCo1VHHjdadQPH4X4IbMQ5u09Le7KSuinNyD5";
  #     labels = [
  #       "native:host"
  #       "ubuntu-latest:docker://node:16-bullseye"
  #       "ubuntu-22.04:docker://node:16-bullseye"
  #     ];
  #   };
  # };

  clan.core.vars.generators.searx = {
    files.key.secret = true;
    script = ''
      ${pkgs.openssl}/bin/openssl rand -base64 32 > $out/key
    '';
  };

  services.searx = {
    enable = true;
    redisCreateLocally = true;
    settings = {
      server.bind_address = "0.0.0.0";
      server.secret_key = config.clan.core.vars.generators.searx.files.key.path;
    };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # List services that you want to enable:

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

  networking.interfaces."enp34s0".useDHCP = true;
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
  #
  #       }
  #     ];
  #     valid-lifetime = 4000;
  #   };
  # };

  programs.nbd.enable = true;

  services.tailscale = {
    permitCertUid = "caddy";
  };

  clan.core.vars.generators.caddy = {
    prompts = {
      porkbun_key = {
        description = "The key to manage porkbun dns records. For use with DNS challenges with caddy.";
      };
      porkbun_secret = {
        description = "The secret to manage porkbun dns records.";
      };
    };

    files.env.secret = true;

    script = ''
      cat << EOF > $out/env
        PORKBUN_API_KEY=$(cat $prompts/porkbun_key)
        PORKBUN_API_SECRET_KEY=$(cat $prompts/porkbun_secret)
      EOF
    '';
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/porkbun@v0.3.1"];
      hash = "sha256-g/Nmi4X/qlqqjY/zoG90iyP5Y5fse6Akr8exG5Spf08=";
    };
    environmentFile = config.clan.core.vars.generators.caddy.files.env.path;
    extraConfig = ''
      (porkbun) {
        tls {
          dns porkbun {
            api_key {env.PORKBUN_API_KEY}
            api_secret_key {env.PORKBUN_API_SECRET_KEY}
          }
          resolvers 1.1.1.1 # https://caddy.community/t/notimp-reponse-to-route53-acme-challenge/25589
        }
      }
    '';
    virtualHosts = let
      str = builtins.toString;
      inherit (config.services) jellyseerr sonarr radarr komga;
    in {
      "jellyfin.kiesen.moe".extraConfig = ''
        reverse_proxy http://127.0.0.1:8096
        import porkbun
      ''; # there is no port config for jellyfin
      "jellyseerr.kiesen.moe".extraConfig = ''
        reverse_proxy http://127.0.0.1:${str jellyseerr.port}
        import porkbun
      '';
      "sonarr.kiesen.moe".extraConfig = ''
        reverse_proxy http://127.0.0.1:${str sonarr.settings.server.port}
        import porkbun
      '';
      "radarr.kiesen.moe".extraConfig = ''
        reverse_proxy http://127.0.0.1:${str radarr.settings.server.port}
        import porkbun
      '';
      "komga.kiesen.moe".extraConfig = ''
        reverse_proxy http://127.0.0.1:${str komga.settings.server.port}
        import porkbun
      '';
      "git.kiesen.moe".extraConfig = ''
        reverse_proxy http://127.0.0.1:3000
        import porkbun
      '';
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
