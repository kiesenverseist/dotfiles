{inputs, ...}: {
  imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "100.120.252.116";
    bridges = ["br0" "virbr0"];
    ceph = {
      enable = true;
      mgr.enable = true;
      mon.enable = true;
      osd = {
        enable = true;
        daemons = ["1"];
      };
    };
  };
}
