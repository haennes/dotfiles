{ lib, config, inputs, system, ... }:
let
  inherit (lib) mapAttrs head length last;
  ips = config.ips.ips.ips.default;
  hports = config.ports.ports.curr_ports;
  ports = config.ports.ports.ports;
  local_linking = {
    sync = hports.syncthing.gui;
    "s.sync" = hports.ssh.syncschlawiner.syncthing.gui;
  };
  linking = {
    "atuin" = [ ips.historia.wg0 ports.historia.atuin ];
    "rss" = [ ips.fons.wg0 ];
    "hydra" = [ ips.deus.wg0 ports.deus.hydra ];
  };
  all_linking = linking // (mapAttrs (_: v: [ "localhost" v ]) local_linking);
in {
  # the tasks ones are managed in tasks.nix

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };
  services.nginx.virtualHosts = {
    "localhost".locations."/".proxyPass = "http://localhost:${
        toString config.services.homepage-dashboard.listenPort
      }";

    "ho.localhost".locations."/".root =
      "${inputs.home-manager-option-search.packages."${system}".default}";
  } // (lib.mapAttrs' (name: value:
    let
      ip = head value;
      port = if (length value) == 2 then last value else null;
      second_part = if port == null then "" else ":${toString port}";
    in {
      name = "${name}.localhost";
      value = { locations."/".proxyPass = "http://${ip}${second_part}"; };
    }) all_linking);
}
