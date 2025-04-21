{ config, ... }:
let
  hports = config.ports.ports.curr_ports;
  ips = config.ips.ips.ips.default;

  port = hports.taskchampion-sync-server;
  hostname = config.networking.hostName;
  dataDir = "/taskw-tasks";
  cfg = config.services.taskchampion-sync-server;
  inherit (cfg) group user;
in {

  system.activationScripts.taskw-ensure-ownership = {
    deps = [ "users" "groups" ];
    text = ''
      mkdir -p ${dataDir}
      chown -R ${user}:${group} ${dataDir} --quiet
    '';
  };
  networking.firewall.interfaces.wg0.allowedTCPPorts = [ port ];
  services.taskchampion-sync-server = {
    enable = true;
    host = ips.${hostname}.wg0;
    inherit dataDir port;
  };
}
