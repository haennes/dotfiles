hostname:
{
  config,
  lib,
  inputs,
  all_modules,
  ...
}:
let
  inherit (lib) mapAttrs;
in
{
  imports = [
    inputs.esw-machines.nixosModules.default
    inputs.esw-gemeinschaft.nixosModules.default
    #inputs.syncthing-wrapper.nixosModules.default
  ]
  ++ all_modules;

  is_server = true;
  is_client = false;
  is_microvm = true;
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.esw ];

  system.activationScripts.ensure-syncthing-dir = ''
    mkdir -p /persist/esw-machines
    touch  /persist/esw-machines/esw
    chown -R ${config.services.esw-machines.user}:${config.services.esw-machines.user} /persist/esw-machines
    mkdir -p /persist/eswg
    chown -R ${config.services.gemeinschaftsraum-buchung.user}:${config.services.gemeinschaftsraum-buchung.user} /persist/eswg
  '';

  services.syncthing-wrapper = {
    enable = true;
  };
  services.syncthing = {
    dataDir = "/persist";
    user = config.services.esw-machines.user;
    group = config.services.esw-machines.user;
  };

  services.esw-machines = {
    enable = true;
    port = config.ports.ports.curr_ports.esw;
    domain = "0.0.0.0";
    dataFilePath = "/persist/esw-machine__esw-machines/esw";
  };

  services.gemeinschaftsraum-buchung = {
    enable = true;
    origin = null;
    host = "0.0.0.0";
    port = config.ports.ports.curr_ports.gesw;
    openFirewall = true;
    dbDir = "/persist/eswg";

    hausPasswortFile = config.age.secrets.hausPasswortFile.path;
    sessionSecretFile = config.age.secrets.sessionSecretFile.path;
  };

  age.secrets =
    mapAttrs
      (
        _: v:
        {
          owner = config.services.gemeinschaftsraum-buchung.user;
          group = config.services.gemeinschaftsraum-buchung.group;
        }
        // v
      )
      {
        hausPasswortFile.file = ../../../secrets/gesw/hausPasswortFile.age;
        sessionSecretFile.file = ../../../secrets/gesw/sessionSecretFile.age;
      };
}
