{ inputs, config, lib, sshkeys, ... }:
let
  ips = config.ips.ips.ips.default;
  hports = config.ports.ports.curr_ports;
in {

  microvm = {
    #...add additional MicroVM configuration here
    interfaces = [{
      type = "tap";
      id = "vm-tabula";
      mac = "${config.macs.macs.vm-host.vm-tabula.eth0}";
    }];

    shares = [{
      source = "/persistant/microvms/tabula/";
      mountPoint = "/persist";
      tag = "persist2-${config.networking.hostName}";
      proto = "virtiofs";
    }];
  };
  system.activationScripts.ensure-ssh-key-dir.text = "mkdir -p /persist";
  services.openssh = {
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
  fileSystems."/persist".neededForBoot = lib.mkForce true;
  age.identityPaths = [ "/persist/root_user_key" ];
  imports = [
    ../../secrets/macs.nix
    ../../secrets/ips.nix
    ../../secrets/ports.nix
    ../../modules/all
    ../../modules/headless
    inputs.IPorts.nixosModules.default
    inputs.wireguard-wrapper.nixosModules.default
    inputs.syncthing-wrapper.nixosModules.default
    inputs.agenix.nixosModules.default
    #../proxmox.nix
    ./nginx.nix
  ];

  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = {
      Address = [ "${ips.vm-tabula.br0}/24" "2001:db8::b/64" ];
      Gateway = ips."vm-host".br0;
      DNS = [ "1.1.1.1" ];
      IPv6AcceptRA = true;
      DHCP = "no";
    };
  };

  networking.useDHCP = lib.mkForce false;

  services.openssh = {
    enable = true; # TODO: extract into module
    ports = [ hports.sshd ];
  };
  users.users.root.openssh.authorizedKeys.keys = [ sshkeys.hannses ];

  services.syncthing_wrapper = { enable = true; };
  services.syncthing = {
    dataDir = "/persist";
    user = "nginx";
  };
  networking.hostName = "tabula";

  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";
}
