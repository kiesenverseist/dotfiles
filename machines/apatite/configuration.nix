{pkgs, ...}: {

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  time.timeZone = "Australia/Sydney";

  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILB44rGxgd27wPLkuUrHXlnrpEhqVQX92k1F3TVNYIWQ kiesen@graphite''];

  users.users.kiesen = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];

    openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILB44rGxgd27wPLkuUrHXlnrpEhqVQX92k1F3TVNYIWQ kiesen@graphite''];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = [
    pkgs.wget
    pkgs.curl
    pkgs.btop
  ];

  # Programs
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.tmux.enable = true;
  programs.neovim.defaultEditor = true;
  programs.htop.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
  };

  # Serivces
  services.openssh.enable = true;

  services.tailscale = {
    enable = true;
    # permitCertUid = "caddy";
  };

}
