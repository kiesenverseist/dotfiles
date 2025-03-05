# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # ./hardware-configuration.nix
    ../cachix.nix
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

  networking.hostName = "vm"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.nameservers = [ "9.9.9.9" "1.1.1.1" ];

  # networking.useDHCP = false;
  # networking.bridges."br0".interfaces = ["eno2"];
  # networking.interfaces."br0".useDHCP = true;

  # virtualisation = {
  #   qemu.guestAgent.enable = true;
  # };

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
  # services.displayManager.sddm = {
  #   enable = true;
  #   # wayland.enable = true;
  # };
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    videoDrivers = ["nvidia"];
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
  };

  security.polkit.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.fish.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };
  programs.gamemode.enable = true;
  # programs.gamescope = {
  #   enable = true;
  #   # capSysNice = true;
  # };

  programs.alvr.enable = true;

  environment.sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    # NIXOS_OZONE_WL = "1";
    FLAKE = "/home/kiesen/.config/system";
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    steam-hardware.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kiesen = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel" "disk"]; # Enable ‘sudo’ for the user.
    initialPassword = "";
  };

  fonts.packages = [pkgs.nerd-fonts.fira-code];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim

    wget
    git

    firefox
    kitty

    nixd
    home-manager
    nh
    nom

    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects

    tailscale

    kdePackages.polkit-kde-agent-1
  ];

  # List services that you want to enable:

  # flatpak
  services.flatpak.enable = true;

  services.tailscale.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  programs.dconf.enable = true;
  programs.nix-ld.enable = true;
  programs.nbd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
