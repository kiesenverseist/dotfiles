{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays."x86_64-linux"
  ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "0.0.0.0";
    bridges = ["br0" "virbr0"];
  };
}
