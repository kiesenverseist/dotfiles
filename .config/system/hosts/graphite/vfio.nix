# IOMMU Group 15:
# 	26:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU106 [GeForce RTX 2060 SUPER] [10de:1f06] (rev a1)
# 	26:00.1 Audio device [0403]: NVIDIA Corporation TU106 High Definition Audio Controller      [10de:10f9] (rev a1)
# 	26:00.2 USB controller [0c03]: NVIDIA Corporation TU106 USB 3.1 Host Controller             [10de:1ada] (rev a1)
# 	26:00.3 Serial bus controller [0c80]: NVIDIA Corporation TU106 USB Type-C UCSI Controller   [10de:1adb] (rev a1)
let
  passthroughIDs = [
    "10de:1f06" # 2060s vga
    "10de:10f9" # ^     audio
    "10de:1ada" # ^     usb 3.1
    "10de:1adb" # ^     usb c
  ];
in
  {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.vfio.enable = lib.mkEnableOption "Configure machine for vfio";

    config = let
      cfg = config.vfio;
    in
      lib.mkIf cfg.enable {
        boot = {
          initrd.kernelModules = [
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
            # "vfio_virqfd"

            # "nvidia"
            # "nvidia_modeset"
            # "nvidia_uvm"
            # "nvidia_drm"
          ];

          kernelParams =
            [
              "amd_iommu=on"
            ]
            ++ lib.optional cfg.enable
            ("vfio-pci.ids=" + lib.concatStringsSep "," passthroughIDs);
        };

        virtualisation.spiceUSBRedirection.enable = true;
      };
  }
# unrelated but looking glass config:
# <shmem name="looking-glass">
#      <model type="ivshmem-plain"/>
#      <size unit="M">64</size>
#      <address type="pci" domain="0x0000" bus="0x10" slot="0x01" function="0x0"/>
#    </shmem>

