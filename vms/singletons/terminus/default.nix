{ inputs, pkgs, lib, config, sshkeys, all_modules, ... }:
let
  hports = config.ports.ports.curr_ports;
  ips = config.ips.ips.ips.default;
  dataDir = "/persist/cal";
in {
  microvm.shares = [{
    source = "/cal";
    mountPoint = dataDir;
    tag = "mc-${config.networking.hostName}";
    proto = "virtiofs";
  }];
  microvm.mem = 400;
  microvm.vcpu = 1;

  imports = [ ../../../modules/microvm_guest.nix ];

  services.wireguard-wrapper.enable = true;
  age.secrets.radicale_pw = {
    file = ../../../secrets/radicale/passwords.age;
    group = "radicale";
    owner = "radicale";
  };
  # services.syncthing = {
  #   dataDir = "/persist";
  #   user = config.services.freshrss.user;
  # };

  networking.hostName = "terminus";

  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [ "${ips.terminus.wg0}:${toString hports.radicale}" ];
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets.radicale_pw.path;
        htpasswd_encryption = "autodetect";
      };
      storage = { filesystem_folder = dataDir; };
    };
  };
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ hports.radicale ];

  # networking.firewall.allowedTCPPorts = [ 443 80 ];

}
