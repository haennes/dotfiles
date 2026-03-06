# shell/python script that automatically generates all required age definitions
{
  inputs,
  config,
  lib,
  ...
}:
let
  haumea = inputs.haumea.lib;
  inherit (lib)
    filterAttrs
    map
    mapAttrs'
    attrValues
    mkEnableOption
    mkIf
    ;
  secret_files = (
    haumea.load {
      src = ../../secrets/networks/secrets;
      loader = haumea.loaders.verbatim;
    }
  );
in
{
  options.my.networkmanager_wifi_rollout =
    mkEnableOption "enable network configuration through network manager"
    // {
      default = config.is_client;
    };
  config = mkIf config.my.networkmanager_wifi_rollout {
    networking.networkmanager.ensureProfiles = {
      profiles = filterAttrs (n: _: n != "secrets") (
        haumea.load {
          src = ../../secrets/networks;
          loader = haumea.loaders.default;
        }
      );
      # secrets.package = inputs.nm-secret-agent.packages.x86_64-linux.default;
      secrets.entries = map (
        v:
        let
          _value = v config;
          # value = (removeAttrs _value [ "matchID" ]) // {
          #   matchId = _value.matchID;
          # };
          # value_fixed = {
          #   inherit (value) file key matchId;
          #   matchSetting = with value;
          #     if matchSetting == "wifi-security" then
          #       "802-11-wireless-security"
          #     else
          #       matchSetting;
          #   matchType = with value;
          #     if matchType == "wifi" then "802-11-wireless" else matchType;
          # };
        in
        _value
      ) (attrValues secret_files);
    };
    age.secrets =
      let
        getPath = v: with v; "${matchId}-${matchType}-${matchSetting}-${key}";
      in
      mapAttrs' (
        n: v:
        let
          pathName = getPath (v config);
        in
        {
          name = pathName;
          value = {
            file = ../../secrets/networks/secrets/${pathName}.age;
          };
        }
      ) secret_files;
  };
}
