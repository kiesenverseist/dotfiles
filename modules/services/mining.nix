{...}: {
  clan.inventory.instances.mining = {
    module.input = "self";
    module.name = "@kiesen/mining";
    roles.default.machines = {
      graphite = {};
    };
  };

  clan.modules."@kiesen/mining" = {
    _class = "clan.service";

    manifest = {
      name = "mining";
      description = "For mining";
      categories = ["System"];
    };

    roles.default = {
      description = "To include this machine for mining";
      interface = {...}: {
        options = {
        };
      };

      perInstance = {...}: {
        nixosModule = {config, ...}: {
          nixpkgs.config.allowUnfree = true;

          clan.core.vars.generators = {
            monero-wallet = {
              share = true;
              prompts.address = {
                persist = true;
                description = "monero wallet address";
              };
              files.address.deploy = false;
            };
            p2pool = {
              files.env.secret = true;
              dependencies = ["monero-wallet"];
              script = ''
                cat << EOF > $out/env
                  MONERO_WALLET=$(cat $in/monero-wallet/address)
                EOF
              '';
            };
          };

          services.monero = {
            enable = true;
            prune = true;
            rpc = {
              address = "127.0.0.1";
              port = 18081;
            };
            extraConfig = ''
              zmq-pub=tcp://127.0.0.1:18083
              enable-dns-blocklist=1
            '';
          };

          services.p2pool = {
            enable = true;
            host = "127.0.0.1";
            rpcPort = 18081;
            zmqPort = 18083;
            sidechain = "mini";
            walletAddress = "$MONERO_WALLET";
            environmentFile = config.clan.core.vars.generators.p2pool.files.env.path;
          };

          services.xmrig = {
            enable = true;
            settings = {
              autosave = false;
              cpu = {
                enabled = true;
                huge-pages = true;
              };
              randomx = {
                mode = "auto";
                wrmsr = true;
              };
              pools = [
                {
                  url = "127.0.0.1:3333";
                  # user = "x";
                  # pass = "x";
                  keepalive = true;
                }
              ];
            };
          };

        };
      };
    };
  };
}
