{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./backups.nix
    ./cachix.nix
  ];

  options.default.enable = lib.mkOption {
    default = true;
    example = false;
    description = "A set of default configs for hosts";
    type = lib.types.bool;
  };

  config = lib.mkIf config.default.enable {
    # enable .local domains
    services = {
      avahi = {
        enable = lib.mkDefault true;
        nssmdns4 = true;
        openFirewall = lib.mkDefault true;
      };

      flatpak.enable = lib.mkDefault true;

      openssh.enable = lib.mkDefault true;
      tailscale.enable = lib.mkDefault true;

      # Enable sound.
      pipewire = {
        enable = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
      };

      fwupd.enable = lib.mkDefault true;
    };

    security.polkit.enable = true;

    time.timeZone = lib.mkDefault "Australia/Sydney";

    # Select internationalisation properties.
    i18n.defaultLocale = lib.mkDefault "en_AU.UTF-8";

    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        trusted-users = ["root" "@wheel"];
      };
      optimise = {
        automatic = lib.mkDefault true;
        dates = ["3:00"];
      };
      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 30d";
      };
    };

    nixpkgs = {
      config.allowUnfree = true;
    };

    programs = {
      zsh.enable = lib.mkDefault true;
      fish.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;

      neovim = {
        enable = true;
        defaultEditor = lib.mkDefault true;
      };

      git.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;

      htop.enable = lib.mkDefault true;

      nh = {
        enable = true;
        flake = lib.mkDefault "/home/kiesen/dotfiles/";
      };

      nix-ld.enable = lib.mkDefault true;

      dconf.enable = lib.mkDefault true;
    };

    environment.systemPackages = [
      pkgs.wget
      pkgs.curl
      pkgs.btop
      pkgs.firefox
      pkgs.home-manager
    ];

    fonts.packages = [pkgs.nerd-fonts.fira-code];

    users.users = {
      kiesen = {
        isNormalUser = true;
        shell = pkgs.fish;
      };
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
