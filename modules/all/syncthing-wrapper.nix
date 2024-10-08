{ config, lib, ... }:
let
  ids = import ../../secrets/not_so_secret/syncthing.key.nix;
  sharedFolderFn = { folder_name, DirUsers, DirGroups }:
    "${config.services.syncthing.dataDir}/${folder_name}";
  family_if_client = (if (config.is_client) then {
    DirGroups = [ "family" ];
    ensureDirExists = "setfacl";
  } else
    { });
in {
  services.syncthing_wrapper = rec {
    DirUsersDefault = [ "hannses" ];
    folderToPathFuncDefault = { folder_name, DirUsers, DirGroups }:
      "${config.services.syncthing.dataDir}/${
        lib.lists.head DirUsers
      }/${folder_name}";
    default_versioning = {
      type = "simple";
      params.keep = "10";
    };
    devices = rec {
      all_pcs = {
        thinknew = ids.thinknew;
        mainpc = ids.mainpc;
        yoga = ids.yoga;
      };
      thinkpad = { thinkpad = ids.thinkpad; };
      all_handys = {
        handyHannes = ids.handyHannes;
        handyAlexandra = ids.handyMum;
        handyThomas = ids.handyThomas;
        tablet = ids.tablet;

      };
      servers = { syncschlawiner = ids.syncschlawiner; };
      all_servers = servers // { tabula = ids.tabula; };

      #uni = {
      #  stefan_handy = ids.stefan_handy;
      #  sebastian_s_mac = ids.sebastian_s_mac;
      #  sebastian_r_laptop = ids.sebastian_r_laptop;
      #};
    };
    folders = with devices;
      with devices.all_handys;
      with devices.all_servers; {
        "Family" = {
          devices = [ (all_pcs // servers) "thinkpad" ];
          folderToPathFunc = sharedFolderFn;
        } // family_if_client;
        "Passwords" = {
          devices = [ (all_pcs // all_handys // servers) "thinkpad" ];
          versioning = {
            type = "simple";
            params.keep = "100";
          };
          folderToPathFunc = sharedFolderFn;
        } // family_if_client;
        "3d_printing" = [ (all_pcs // servers) ];
        "Documents" = [ (all_pcs // servers) ];
        "Notes" = [ (all_pcs // servers) ];
        "tasks" = {
          devices = [ (all_pcs // servers) ];
          paths = { syncschlawiner = "/data/syncthing/hannses/tasks"; };
        };
        "Downloads" = [ (all_pcs // servers) ];
        "Music" = [ (all_pcs // servers) ];
        "Pictures" = [ (servers // all_pcs) ];
        "Templates" = [ (all_pcs // servers) ];
        "Videos" = [ (all_pcs // servers) ];
        "game_servers" = [ (all_pcs // servers) ];
        "programming" = [ (all_pcs // servers) ];
        "AegisBak" = [ (all_pcs // servers) "handyHannes" ];
        "AntennaBak" = {
          devices = [ (all_pcs // servers) "handyHannes" ];
          paths = { syncschlawiner = "/data/syncthing/hannses/AntennaBak"; };
        };
        "SignalBackup" = [ (servers) "handyHannes" ];
        "DownloadHandyH" = [ (all_pcs // servers) "handyHannes" ];
        "HannesKamera" = [ (all_pcs // servers) "handyHannes" ];
        "HannesGalerie" = [ (all_pcs // servers) "handyHannes" ];
        "AlexandraKamera" = [ (servers) "handyAlexandra" ];
        "AlexandraGalerie" = [ (servers) "handyAlexandra" ];
        "ThomasKamera" = [ (servers) ];
        "ThomasGalerie" = [ (servers) ];
        "website" = [ (all_pcs) "tabula" ];
      };
  };

  services.syncthing = {
    settings = {
      options = {
        urAccepted = -1; # do not send reports
        relaysEnabled = true;
      };
    };
    guiAddress =
      "127.0.0.1:${toString config.ports.ports.curr_ports.syncthing.gui}";
    key = lib.mkIf (config.services.syncthing.enable)
      config.age.secrets."syncthing_key_${config.networking.hostName}".path;
    cert = lib.mkIf (config.services.syncthing.enable)
      config.age.secrets."syncthing_cert_${config.networking.hostName}".path;
  };
}
