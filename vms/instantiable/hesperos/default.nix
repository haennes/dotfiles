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

  microvm.mem = 256;
  networking.hostName = hostname;

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
