{ config, ips, lib, ... }:
with ips;
let
  hostname = config.networking.hostName;
  cfg = config.services.wireguard-wrapper;
  secrets = import ../../lib/wireguard;
  our_connections =
    builtins.filter (l: (builtins.elem hostname l)) cfg.connections;
in with lib;
with lib.types; {
  options.services.wireguard-wrapper = {
    enable = mkEnableOption "wireguard-wrapper";
    mtu = mkOption {
      type = int;
      default = 1300;
    };
    privateKeyFile = mkOption { type = path; };
    publicKey = mkOption { type = anything; };

    port = mkOption {
      type = types.port;
      default = 51820;
    };
    openPort = mkOption {
      type = bool;
      default = true;
    };
    connections = mkOption { type = listOf (listOf str); };
    nodes = mkOption {
      type = attrsOf (submodule ({
        options = {
          #devname = mkOption {
          #  type = str;
          #  default = name;
          #  description = lib.mdDoc ''
          #    The name of the device.
          #  '';
          #};
          endpoint = mkOption {
            type = nullOr str;
            default = null;
            description = mdDoc ''
              set if this is an endpoint
            '';
            example = "wg.example.com:51820";
          };
          ips = mkOption {
            type = listOf str;
            description =
              mdDoc "  first: own ip, all: ips that this peer can forward\n";
          };
        };
      }));
    };
  };
  config = mkIf cfg.enable ({
    networking.firewall.allowedUDPPorts = mkIf cfg.openPort [ cfg.port ];

    networking.wireguard.interfaces = {
      "wg0" = {
        ips = [ (builtins.head cfg.nodes."${hostname}".ips) ];
        mtu = cfg.mtu;
        privateKeyFile = cfg.privateKeyFile;
        listenPort = cfg.port;
        peers = (builtins.map (l:
          let
            other = (lib.head (lib.remove hostname l));
            other_node = cfg.nodes."${other}";
          in ({
            name = other;
            publicKey = ((cfg.publicKey) other);
            allowedIPs = (other_node.ips);
            persistentKeepalive = 25;
            endpoint = other_node.endpoint;
          })) our_connections);
      };
    };

  });
}
