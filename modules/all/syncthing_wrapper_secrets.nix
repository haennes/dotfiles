{ config, lib, ... }:
let dev_name = config.networking.hostName;
in {
  config = lib.mkIf (config.services.syncthing-wrapper.enable) {
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
