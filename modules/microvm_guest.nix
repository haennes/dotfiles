{ config, lib, all_modules, server_modules, microvm_modules_guest, ... }:
let ips = config.ips.ips.ips.default;
in {
  imports = all_modules ++ server_modules ++ microvm_modules_guest;
  microvm = {
    #...add additional MicroVM configuration here
    interfaces = [{
      type = "tap";
      id = "vm-tabula";
      mac = "${config.macs.macs.vm-host.vm-tabula.eth0}";
    }];

    shares = [
      {
        source = "/persistant/microvms/${config.networking.hostName}/";
        mountPoint = "/persist";
        tag = "persist-${config.networking.hostName}";
        proto = "virtiofs";
      }
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];
  };
  fileSystems."/persist".neededForBoot = lib.mkForce true;

  system.activationScripts.ensure-ssh-key-dir.text = "mkdir -p /persist";
  services.openssh = {
    hostKeys = [
      {
        path = "/persist/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
  age.identityPaths = [ "/persist/root_user_key" ];

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
}
