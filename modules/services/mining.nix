{...}: {
  clan.inventory.instances.mining = {
    module.input = "self";
    module.name = "@kiesen/mining";
    roles.node.machines.graphite = {};
    roles.miner.machines = {
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

    roles.node = {
      description = "The machine that runs the monero node";
      interface = {...}: {
        options = {
        };
      };

      perInstance = {...}: {
        nixosModule = {config, ...}: {
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
              files.env.owner = "p2pool";
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
            host = "0.0.0.0";
            rpcPort = 18081;
            zmqPort = 18083;
            sidechain = "mini";
            walletAddress = "$MONERO_WALLET";
            environmentFile = config.clan.core.vars.generators.p2pool.files.env.path;
          };

        };
      };
    };


    roles.miner = {
      description = "To include this machine for mining";
      interface = {...}: {
        options = {
        };
      };

      perInstance = {roles, ...}: {
        nixosModule = {config, ...}: {
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
                  url = let
                    node = builtins.elemAt roles.node.machines 0;
                  in "${node.name}.${config.clan.core.settings.domain}:3333";
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
