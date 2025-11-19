hostname:
{ config, pkgs, lib, ... }: {
  imports = [ ../../../modules/microvm_guest.nix ];

  #systemd.services."openfortivpn" = {
  #  script = ''
  #    set -eu
  #    ${pkgs.openfortivpn}/bin/openfortivpn
  #  '';
  #  requires = [ "network.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    user = "root";
  #  };
  #};

  services.openssh.settings = {
    GatewayPorts = "yes";
    AllowTcpForwarding = "yes";
  };
  microvm.mem = 256;
  networking.hostName = hostname;
  services.wireguard-wrapper.enable = true;

  system.stateVersion = "23.11";

  age.secrets."openfortivpn.age" = {
    file = ../../../secrets/openfortivpn.age;
    owner = "root";
    group = "root";
  };

  environment = {
    etc = {
      "openfortivpn/config".source = config.age.secrets."openfortivpn.age".path;

    };
    systemPackages = with pkgs; [ openfortivpn ];
  };

}
