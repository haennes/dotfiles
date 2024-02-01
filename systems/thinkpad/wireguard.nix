{config, lib, pkgs, ...}:
let
  secrets = import ../../lib/wireguard;
  pub_key = ((secrets.obtain_wireguard_pub{hostname = "welt";}).key);
  priv_key = secrets.age_obtain_wireguard_priv{hostname = config.networking.hostName;};
in  {
    #networking.firewall = {
    #  allowedUDPPorts = [ 59876 ]; # Clients and peers can use the same port, see listenport
    #};

    networking.firewall = {
      allowedTCPPorts = [22];
      allowedUDPPorts = [51821];
    };
  # Enable WireGuard
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "192.168.178.203/24" ];
      mtu = 1300;
      listenPort = 51821; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = config.age.secrets.wireguard_thinkpad_wg0_private.path;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = pub_key;


          #presharedKey = "KdK8tVAg5AhYuwQgVhbzsrBzju1pJR1vFg5FzPIdOLQ=";
          # Forward all the traffic via VPN.
          allowedIPs = [ "192.168.178.0/24" ];
          # Or forward only particular subnets
          #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

          # Set this to the server IP and port.
          endpoint = "hannses.de:51821"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 5 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  #services.dnsmasq = {
  #  enable = true;
  #  settings.interface = "wg0";
  #};
}
// priv_key
