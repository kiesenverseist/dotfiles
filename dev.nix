{
  # inputs,
  lib,
  options,
  ...
}: {
  # imports = [
  #   inputs.devenv.flakeModule
  # ];

  # Required for evaluating module option values.
  debug = true;
  flake = {
    optnix.options-doc =
      builtins.unsafeDiscardStringContext
      (builtins.toJSON (lib.optionAttrSetToDocList options));
  };

  perSystem = {
    pkgs,
    # system,
    inputs',
    ...
  }: {
    # packages = {
    #   vm = inputs.nixos-generators.nixosGenerate {
    #     inherit system pkgs;
    #     specialArgs = {inherit inputs;};
    #     modules = [
    #       ./hosts/vm
    #       ({lib, ...}: {
    #         system.build.qcow = lib.mkDefault {
    #           diskSize = lib.mkForce "auto";
    #           additionalSpace = "10G";
    #         };
    #       })
    #     ];
    #     format = "qcow";
    #   };
    # };

    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.age
        pkgs.ssh-to-age
        pkgs.sops
        pkgs.nh
        pkgs.optnix
        inputs'.clan-core.packages.clan-cli
        (pkgs.writeShellApplication {
          name = "build-iso";
          text = "nix build .#nixosConfigurations.iso.config.system.build.isoImage";
        })
      ];
    };

    # devenv.shells.default = {
    #   packages = [
    #     pkgs.age
    #     pkgs.ssh-to-age
    #     pkgs.sops
    #     pkgs.nh
    #     pkgs.optnix
    #   ];
    # };

    formatter = pkgs.alejandra;
  };
}
