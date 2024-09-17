{ modulesPath, config, lib, pkgs, sshkeys, ips, ... }:
let inherit (ips) ip_cidr subnet_cidr;
in {

  imports = [ ./hardware-configuration.nix ./nginx.nix ./dns.nix ];
  boot.loader = {
    grub.enable = true;
    grub.device = "/dev/sda15";
    grub.forceInstall = true;
  };
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "welt";
  networking.domain = "hannses.de";

  services.wireguard-wrapper.enable = true;
  networking.nat.enable = true;
  networking.wireguard.interfaces.wg0 =
  let
    net = subnet_cidr lib ips.welt.wg0;
  in {
    # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
    # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
    postSetup = ''
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${net} -o ens3 -j MASQUERADE
    '';

    # This undoes the above command
    postShutdown = ''
      ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${net} -o ens3 -j MASQUERADE
    '';
  };

  system.stateVersion = "23.11";
}
