{config, lib, pkgs, ...}:
 let 
  secrets = import ../../lib/wireguard;
  pub_key = ((secrets.obtain_wireguard_pub{hostname = "welt";}).key); 
  priv_key = secrets.age_obtain_wireguard_priv{hostname = config.networking.hostName; };

in
{
    networking.firewall = {
      allowedUDPPorts = [51821];
    };

    #networking.firewall.enable = false;
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "192.168.1.4/32" ];
      listenPort = 51821; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      mtu = 1300;

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.

      privateKeyFile = config.age.secrets.wireguard_porta_wg0_private.path;
      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).


          publicKey = pub_key;
          # Or forward only particular subnets
          allowedIPs = [ "192.168.1.3/32" ];

          # Set this to the server IP and port.
          endpoint = "hannses.de:51821"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 5 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
// priv_key 
