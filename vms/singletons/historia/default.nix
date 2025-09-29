{ inputs, pkgs, lib, config, sshkeys, all_modules, ... }:
let ips = config.ips.ips.ips.default;
in {

  imports = [ ../../../modules/microvm_guest.nix ];

  services.wireguard-wrapper.enable = true;

  networking.firewall.interfaces.wg0.allowedTCPPorts =
    [ config.ports.ports.curr_ports.atuin ];
  networking.firewall.allowedTCPPorts = [ config.ports.ports.curr_ports.atuin ];
  networking.hostName = "historia";

  system.activationScripts.ensure-dirs-exist.text =
    let pg = config.services.postgresql.dataDir;
    in ''
      mkdir -p ${pg}
      chown postgres:postgres ${pg}
    '';
  # official test: https://github.com/NixOS/nixpkgs/blob/master/nixos/tests/atuin.nix
  services.atuin = {
    enable = true;
    database.createLocally = true;
    openRegistration = true;
    openFirewall = false;
    host = ips.historia.wg0;
    port = config.ports.ports.curr_ports.atuin;
  };

  services.postgresql.dataDir = "/persist/pg";
}
