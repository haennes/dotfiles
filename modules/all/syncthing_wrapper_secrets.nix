{ config, lib, ... }:
let
  dev_name = config.services.syncthing_wrapper.dev_name;
  secrets = import ../../lib/wireguard;
  priv_key = hostname: secrets.age_obtain_wireguard_priv { inherit hostname; };
in {
  config = lib.mkIf (config.services.syncthing_wrapper.enable) {
    age.secrets.${"syncthing_key_${dev_name}"} = {
      owner = config.services.syncthing.user;
      file = ../../secrets/syncthing/${dev_name}/key.age;
    };
    age.secrets.${"syncthing_cert_${dev_name}"} = {
      owner = config.services.syncthing.user;
      file = ../../secrets/syncthing/${dev_name}/cert.age;
    };
  };
}
