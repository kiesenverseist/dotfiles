{inputs, ...}: {
  meta = {
    nixpkgs = import inputs.nixpkgs-stable {system = "x86_64-linux";};
  };

  defaults = {pkgs, ...}: {
    programs.fish.enable = true;
    programs.git.enable = true;
    programs.tmux.enable = true;
    programs.neovim.defaultEditor = true;
    programs.htop.enable = true;

    environment.systemPackages = [pkgs.wget pkgs.curl pkgs.btop];
  };

  lazurite = {name, ...}: {
    imports = [./lazurite];

    deployment = {
      targetHost = name; # tailscale means hostname is the domain name
      targetUser = "root";
    };

    networking.hostName = name;
  };
}
