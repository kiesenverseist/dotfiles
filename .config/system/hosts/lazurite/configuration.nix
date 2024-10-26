{pkgs, ...}: {
  boot.tmp.cleanOnBoot = true;
  # zramSwap.enable = true;
  time.timeZone = "Australia/Sydney";

  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILB44rGxgd27wPLkuUrHXlnrpEhqVQX92k1F3TVNYIWQ kiesen@graphite''];

  users.users.kiesen = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];

    openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILB44rGxgd27wPLkuUrHXlnrpEhqVQX92k1F3TVNYIWQ kiesen@graphite''];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = [
    pkgs.wget
  ];

  # Programs
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.tmux.enable = true;
  programs.neovim.defaultEditor = true;
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

  services.caddy = {
    enable = true;

    virtualHosts."152.69.171.68".extraConfig = ''
      respond "Hello, world! from ip"
    '';

    virtualHosts."hello.kiesen.moe".extraConfig = ''
      respond "Hello, world!"
    '';

    # virtualHosts."sf.kiesen.moe".extraConfig = ''
    #   reverse_proxy graphite.ladon-minnow.ts.net
    # '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "creativeibi77@gmail.com";
  };

  networking = let
    graphite = "100.119.227.45";
    halite = "100.120.252.116";
  in {
    hostName = "lazurite";
    domain = "subnet09102314.vcn09102314.oraclevcn.com";

    nat = {
      enable = true;
      externalInterface = "tailscale0";
      internalInterfaces = ["ens3"];
      forwardPorts = let
        entry = ip: src: dest: [
          {
            destination = "${ip}:${toString dest}";
            proto = "tcp";
            sourcePort = src;
          }
          {
            destination = "${ip}:${toString dest}";
            proto = "udp";
            sourcePort = src;
          }
        ];
        dentry = ip: port: entry ip port port;
      in
        []
        ++ (dentry graphite 7777)
        ++ (dentry halite 25565);
    };

    nftables = {
      enable = true;
      ruleset = let
        entry = ip: port: ''
          iifname "ens3" tcp dport ${toString port} dnat to ${ip}:${toString port}
          iifname "ens3" udp dport ${toString port} dnat to ${ip}:${toString port}
        '';
      in ''
        table ip nat {
          chain PREROUTING {
            type nat hook prerouting priority dstnat; policy accept;
            ${entry graphite 7777}
            ${entry halite 25565}
          }
        }
      '';
    };

    firewall = let
      common = [
        7777 # satisfactory
        25565 # minecraft: vault hunters
      ];
    in {
      allowedTCPPorts =
        [
          80
          443 # http and https
        ]
        ++ common;
      allowedUDPPorts = [] ++ common;
    };
  };

  system.stateVersion = "23.11";
}
