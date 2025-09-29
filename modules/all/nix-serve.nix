{ lib, config, pkgs, ... }:
let hostname = config.networking.hostName;
in {

  config = lib.mkIf config.services.nix-serve.enable {
    nix.settings.allowed-users = [ "nix-serve" ];

    users.users.nix-serve = {
      isSystemUser = true;
      group = "nix-serve";
    };
    users.groups.nix-serve = { };
    age.secrets."nix-serve/${hostname}/priv.age" = {
      file = ../../secrets/nix-serve/${hostname}/priv.age;
      mode = "600";
      owner = "nix-serve";
      group = "nix-serve";
    };
    services.nix-serve = {
      secretKeyFile = config.age.secrets."nix-serve/${hostname}/priv.age".path;
      port = config.ports.ports.curr_ports.nix-serve;
      bindAddress = config.ips.ips.ips.default.${hostname}.wg0;
      package = pkgs.nix-serve-ng;
    };
    networking.firewall.interfaces.wg0.allowedTCPPorts =
      [ config.ports.ports.curr_ports.nix-serve ];
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "nix-serve.local.hannses.de" = {
          locations."/".proxyPass =
            "http://${config.services.nix-serve.bindAddress}:${
              toString config.services.nix-serve.port
            }";
        };
      };
    };
  };
}
