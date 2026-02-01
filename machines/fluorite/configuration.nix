# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    ../../hosts/modules
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.systemd-boot.configurationLimit = 20;

  networking.hostName = "fluorite";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    # dms-greeter = {
    #   enable = true;
    #   compositor.name = "hyprland";
    # };
    defaultSession = "hyprland-uwsm";
  };
  services.desktopManager.plasma6.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.dsearch.enable = true;

  services.backups.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };
  programs.gamemode.enable = true;
  services.joycond.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      dns = ["1.1.1.1" "8.8.8.8"];
    };
  };

  # virtualisation
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  services.zerotierone = {
    enable = true;
  };

  services.samba = {
    enable = true;
    settings.global = {
      "client min protocol" = "smb2";
    };
  };

  programs.adb.enable = true;

  services.kanata = {
    enable = true;
    keyboards."builtin".config = ''
      (defsrc
        caps)

      (deflayermap (default-layer)
        ;; tap caps lock as caps lock, hold caps lock as left control
        caps (tap-hold 100 100 caps lctl))
    '';
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
