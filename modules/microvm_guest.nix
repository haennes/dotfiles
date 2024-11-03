{ config, lib, all_modules, server_modules, microvm_modules_guest, ... }:
let ips = config.ips.ips.ips.default;
in {
  imports = all_modules ++ server_modules ++ microvm_modules_guest;
  is_microvm = true;
  is_client = false;
  microvm = {
    #...add additional MicroVM configuration here
    interfaces = [{
      type = "tap";
      id = "vm-${config.networking.hostName}";
      mac = config.macs.macs.vm-host.${config.networking.hostName}.eth0;
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

  networking.useNetworkd = false;
  systemd.network.enable = true;
  systemd.network.networks."20-lan" = {
    matchConfig.Type = "ether";
    networkConfig = let ip = ips.${config.networking.hostName}.br0;
    in {
      Address = [ "${ip}/24" ];
      Gateway = ips."vm-host".br0;
      DNS = [ "1.1.1.1" ];
      IPv6AcceptRA = true;
      DHCP = "no";
    };
  };

  networking.useDHCP = lib.mkForce false;
}
