# IOMMU Group 15:
# 	26:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU106 [GeForce RTX 2060 SUPER] [10de:1f06] (rev a1)
# 	26:00.1 Audio device [0403]: NVIDIA Corporation TU106 High Definition Audio Controller      [10de:10f9] (rev a1)
# 	26:00.2 USB controller [0c03]: NVIDIA Corporation TU106 USB 3.1 Host Controller             [10de:1ada] (rev a1)
# 	26:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU106 USB Type-C UCSI Controller   [10de:1adb] (rev a1)

let
  passthroughIDs = [
    # "10de:1f06"
    # "10de:10f9"
    # "10de:1ada"
    # "10de:1adb"
    "10de:1c82" # 1050ti vga
    "10de:0fb9" #  ^     audio

    # "1022:1457" # hd audio
    # "1022:145f" #usb ?
  ];
in {pkgs, lib, config, ...}: {
  options.vfio.enable = lib.mkEnableOption "Configure machine for vfio";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        # "vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = [
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable 
        ("vfio-pci.ids=" + lib.concatStringsSep "," passthroughIDs);
    };

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
