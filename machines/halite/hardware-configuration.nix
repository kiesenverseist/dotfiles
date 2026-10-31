{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "bcache"];
  # boot.initrd.kernelModules = [ ];
  boot.kernelModules = ["kvm-amd" "vfio-pci"];
  # boot.extraModulePackages = [ ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 133;
  };

  # boot.kernelParams = ["hugepagesz=1G" "hugepages=24"];

  fileSystems."/" = {
    device = "UUID=e0644bf4-482d-4d43-a927-1033fb82e8da";
    fsType = "bcachefs";
    options = ["x-systemd.mount-timeout=5m"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [];

  zramSwap.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp34s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
