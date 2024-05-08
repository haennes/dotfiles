{ lib, config, ... }:
let
  secrets = import ../../lib/wireguard;
  priv_key = hostname: secrets.age_obtain_wireguard_priv { inherit hostname; };
in {
  config = lib.mkIf (config.services.syncthing_wrapper.enable) ({
    services.syncthing_wrapper.privateKeyFile =
      config.age.secrets."wireguard_${config.networking.hostName}_wg0_private".path;
  } // priv_key (config.networking.hostName));
}
