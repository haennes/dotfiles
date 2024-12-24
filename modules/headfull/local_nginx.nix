{ lib, config, inputs, system, topology, pkgs, ... }:
let
  inherit (lib) mapAttrs head length last;
  ips = config.ips.ips.ips.default;
  hports = config.ports.ports.curr_ports;
  ports = config.ports.ports.ports;
  local_linking = {
    sync = hports.syncthing.gui;
    "s.sync" = hports.ssh.syncschlawiner.syncthing.gui;
  };
  topology_out = topology.x86_64-linux.config.output;
  linking = {
    "atuin" = [ ips.historia.wg0 ports.historia.atuin ];
    "rss" = [ ips.fons.wg0 ];
    "hydra" = [ ips.dea.wg0 ports.dea.hydra ];
  };
  all_linking = linking // (mapAttrs (_: v: [ "localhost" v ]) local_linking);
  write_index_with_file_ref = path:
    pkgs.writeTextFile {
      name = "indexhtml";
      text = ''
        <body style="margin: 0; overflow: hidden;">
            <img src="${path}" style="width: 100%; height: 100%; object-fit: contain;">
        </body>
      '';
    };
  nginx_file_serve_topology = svg_name:
    pkgs.stdenv.mkDerivation {
      name = "main";
      src = topology_out;
      phases = [ "unpackPhase" ];
      unpackPhase = ''
        mkdir $out
        cp ${write_index_with_file_ref svg_name} $out/index.html
        cp $src/${svg_name} $out/${svg_name}
      '';
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

    "net.topo.localhost".locations."/".root =
      nginx_file_serve_topology "network.svg";
    "topo.localhost".locations."/".root = nginx_file_serve_topology "main.svg";
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
