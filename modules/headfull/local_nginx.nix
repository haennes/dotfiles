{ lib, config, inputs, system, ... }:
let
  hports = config.ports.ports.curr_ports;
  linking = {
    sync = hports.syncthing.gui;
    "s.sync" = hports.ssh.syncschlawiner.syncthing.gui;
  };
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
  } // (lib.mapAttrs' (name: value: {
    name = "${name}.localhost";
    value = { locations."/".proxyPass = "http://localhost:${toString value}"; };
  }) linking);
}
