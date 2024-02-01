{config, lib, pkgs, ...}:
let 
  secrets = import ../../lib/wireguard;
  pub_key = ((secrets.obtain_wireguard_pub{hostname = "porta";}).key); 
  priv_key = secrets.age_obtain_wireguard_priv{hostname = config.networking.hostName; };

in
{
#  networking.nat.enable = true;
#  networking.nat.externalInterface = "eth0";
#  networking.nat.internalInterfaces = [ "wg0" ];
#  networking.firewall = {
#    allowedUDPPorts = [ 51821 ];
#  };

  #networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "192.168.1.3/32" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51821;
      mtu = 1300;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
#      postSetup = ''
#        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
#      '';

      # This undoes the above command
#      postShutdown = ''
#        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
#      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      
      #privateKey = "";
      privateKeyFile = config.age.secrets.wireguard_welt_wg0_private.path;

      peers = [
        # List of allowed peers.
        { # Feel free to give a meaning full name
          # Public key of the peer (not a file path).
	  # TODO
	  #publicKey ="";
          publicKey = pub_key;
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "192.168.1.4/32" ];
	  persistentKeepalive = 25;
        }
      ];
    };
  };
}
// priv_key 
