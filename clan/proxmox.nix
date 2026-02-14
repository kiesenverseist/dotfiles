{
  _class = "clan.service";
  manifest.name = "proxmox";
  roles.default = {
    interface = {lib, ...}: {
      options = {
        ipAddress = lib.mkOption {
          type = lib.types.str;
          description = ''
            The external facing ip adrress of this node that will be used when clustering. This ip should point to this machine's hostname.
          '';
        };
        bridges = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["br0"];
          description = ''
            The network bridges to expose to proxmox
          '';
        };
      };
    };
    perInstance = {
      settings,
      lib,
      roles,
      ...
    }: {
      nixosModule = {
        inputs,
        config,
        pkgs,
        ...
      }: {
        imports = [inputs.proxmox-nixos.nixosModules.proxmox-ve];

        nixpkgs.overlays = [inputs.proxmox-nixos.overlays."x86_64-linux"];

        services.proxmox-ve = {
          enable = false;
          ipAddress = settings.ipAddress;
          bridges = ["br0"];
          # ceph = {
          #   enable = true;
          #   mgr.enable = true;
          #   mon.enable = true;
          #   osd = {
          #     enable = true;
          #     daemons = ["1"];
          #   };
          # };
        };

        # proxmox machines should have ssh access to each other

        # clan.core.vars.generators.ssh-proxmox = {
        #   files."proxmox" = {};
        #   files."proxmox.pub".secret = false;
        #   runtimeInputs = [
        #     pkgs.coreutils
        #     pkgs.openssh
        #   ];
        #   script = ''
        #     ssh-keygen -t ed25519 -N "" -C "" -f "$out"/proxmox
        #   '';
        # };
        #
        # systemd.tmpfiles.rules = let 
        #   key-path = config.clan.core.vars.generators.ssh-proxmox.files.proxmox.path;
        # in [
        #   "L /root/.ssh/proxmox - - - - ${key-path}"
        # ];
        #
        # users.users.root.openssh.authorizedKeys.keyFiles = lib.pipe roles.default.machines [
        #   builtins.attrNames
        #   (map (host: "${config.clan.core.settings.directory}/vars/per-machine/${host}/ssh-proxmox/proxmox.pub/value"))
        # ];

        # i can't quite get the above to work, so:
        # services.openssh.settings.PasswordAuthentication = lib.mkForce true;
      };
    };
  };
}
