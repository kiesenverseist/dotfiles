{
  inputs,
  pkgs,
  system,
  ...
}: {
  imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.${system}
  ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "0.0.0.0";
    bridges = ["br0" "virbr0"];
  };
}
