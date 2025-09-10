{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";

    # there isn't space for more
    configurationLimit = 1;
  };

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
  boot.initrd.kernelModules = ["nvme"];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AA62-3E59";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/mapper/ocivolume-root";
    fsType = "xfs";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024;
    }
  ];
}
