{ config, ... }:
let
  ips = config.ips.ips.ips.default;
  dataDir = "/var/lib/anki-sync-server";
in {

  microvm.shares = [{
    source = "/ankisync";
    mountPoint = "/var/lib";
    tag = "ankisync-${config.networking.hostName}";
    proto = "virtiofs";
  }];

  age.secrets."ankisync/pwhannses.age".file =
    ../../secrets/ankisync/pwhannses.age;
  imports = [ ../../modules/microvm_guest.nix ];

  services.wireguard-wrapper.enable = true;

  networking.firewall.interfaces.wg0.allowedTCPPorts =
    [ config.ports.ports.curr_ports.ankisync ];
  networking.hostName = "minerva";

  system.activationScripts.ensure-dirs-exist.text = ''
    mkdir -p ${dataDir}
  '';
  services.anki-sync-server = {
    enable = true;
    address = ips.minerva.wg0;
    port = config.ports.ports.curr_ports.ankisync;

    users = [{
      username = "hannses";
      passwordFile = config.age.secrets."ankisync/pwhannses.age".path;
    }];
  };
}
