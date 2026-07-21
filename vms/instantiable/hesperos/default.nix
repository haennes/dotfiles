hostname:
{
  config,
  pkgs,
  lib,
  all_modules,
  ...
}:
{
  imports = all_modules;
  is_server = true;
  is_client = false;
  is_microvm = true;

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
