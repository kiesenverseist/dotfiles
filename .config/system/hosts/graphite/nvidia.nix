{lib, config, ...}: {
  config = lib.mkIf (!config.vfio.enable) {
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      prime = {
        sync.enable = true;        
        amdgpuBusId = "PCI:12:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # services.xserver.enable = lib.mkForce false;

    services.xserver.videoDrivers = lib.mkForce ["nvidia" "amdgpu"];

    virtualisation.libvirtd.enable = lib.mkForce false;

    # environment.variables = {
    #   LIBVA_DRIVER_NAME = "nvidia";
    #   XDG_SESSION_TYPE = "wayland";
    #   GBM_BACKEND = "nvidia-drm";
    #   __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # }; 

    # boot.blacklistedKernelModules = [
    #   "amdgpu"
    # ];

    # boot.kernelParams = [
    #   "initcall_blacklist=simpledrm_platform_driver_init"
    #   "nvidia-drm.modeset=1"
    #   "nvidia-drm.fbdev=1"
    # ];

  };
}

