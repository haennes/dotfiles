{config, ips, lib, ...}:
with ips;
let 
  hostname = config.networking.hostName;
  cfg = config.services.wireguard-wrapper;
  nodes = { 
    welt = {
      ips = [
        (ip_cidr welt.wg0)
        (subnet_cidr lib welt.wg0)
      ]; #first: own ip, all: ips that this peer can forward
      endpoint = "hannses.de:51821"; # else null
      }; 
    porta.ips = [(ip_cidr porta.wg0)]; 
    syncschlawiner.ips = [(ip_cidr syncschlawiner.wg0)];
    syncschlawiner_mkhh.ips = [(ip_cidr syncschlawiner_mkhh.wg0)];
    tabula.ips = [(ip_cidr tabula.wg0)];
    thinkpad.ips = [(ip_cidr thinkpad.wg0)];
    handy_hannses.ips = [(ip_cidr handy_hannses.wg0)];
    mainpc.ips = [(ip_cidr mainpc.wg0)];
  };
  connections = [
    # connect to specific interface like this: ["porat%wg0" "welt%wg1"]
    ["tabula" "welt"]
    ["porta" "welt"]
    ["syncschlawiner" "welt"]
    ["syncschlawiner_mkhh" "welt"]
    ["handy_hannses" "welt"]
    ["thinkpad" "welt"]
    ["mainpc" "welt"]
  ];
  secrets = import ../lib/wireguard;
  priv_key = secrets.age_obtain_wireguard_priv{inherit hostname;};
  our_connections = builtins.filter ( l: (builtins.elem hostname l)) connections;

in
with lib; with lib.types;{
  options.services.wireguard-wrapper = {
    enable = mkEnableOption "wireguard-wrapper";
    mtu = mkOption{
      type = int;
      default = 1300;
    };
    privateKeyFile = mkOption{
      type = path;
      default = config.age.secrets."wireguard_${hostname}_wg0_private".path;
    };
  };
  config = mkIf cfg.enable ({
    networking.firewall.allowedUDPPorts = [51821];

    networking.wireguard.interfaces = {
      "wg0" = {
        ips = [(builtins.head nodes."${hostname}".ips)];
	mtu = cfg.mtu;
	privateKeyFile = cfg.privateKeyFile;
	listenPort = 51821;
	peers = (builtins.map (l:
          let 
	    other = (lib.head (lib.remove hostname l));
	    other_node = nodes."${other}";
          in 
	  ({	 
	    name = other; 
	    publicKey = ((secrets.obtain_wireguard_pub{hostname = other;}).key); 
	    allowedIPs = (other_node.ips);
	    persistentKeepalive = 25;
	    endpoint = (if other_node ? endpoint then other_node.endpoint else null);
	  })
	) our_connections);
      };
    };

  } // priv_key);
}
