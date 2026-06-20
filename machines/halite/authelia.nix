{inputs, ...}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    inputs.self.nixosModules.backstitch-sync-server
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  # services.minecraft-servers = {
  #   enable = true;
  #   eula = true;
  #   servers = {
  #     vault-hunters = {
  #       enable = true;
  #
  #     };
  #   };
  # };

  services.backstitch-sync-server = {
    enable = true;
    httpPort = 3001;
  };
}
