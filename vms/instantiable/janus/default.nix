hostname:
{ config, lib, ... }:
{
  imports = [
    ./vsftpd.nix
  ];

  is_server = true;
  is_client = false;
  is_microvm = true;
  services.syncthing-wrapper = {
    enable = true;
    paths.system.pathFunc =
      { folderID, physicalPath, ... }:
      let
        cfg = config.services.syncthing-wrapper;
        cfg_s = config.services.syncthing;
        optionalUser = cfg.idToOptionalUserName folderID;
        middle = lib.optionalString (optionalUser != null) "/${optionalUser}";
        legacyID = cfg_s.settings.folders.${folderID}.id;
      in
      "${physicalPath}${middle}/${legacyID}";
  };
  services.syncthing = {
    dataDir = "/persist";
    user = "nginx";
  };
  microvm.mem = 256;
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

}
