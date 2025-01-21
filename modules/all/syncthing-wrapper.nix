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
  imports = [ ./syncthing_wrapper_secrets.nix ];
  services.syncthing_wrapper = rec {
    ensureServiceOwnerShip = true;
    DirUsersDefault = [ "hannses" ];
    folderToPathFuncDefault =
      lib.mkIf (config.networking.hostName != "syncschlawiner")
      ({ folder_name, DirUsers, DirGroups }:
        "${config.services.syncthing.dataDir}/${
          lib.lists.head DirUsers
        }/${folder_name}");
    default_versioning = {
      type = "simple";
      params.keep = "10";
    };
    devices = with ids; rec {
      all_pcs = { inherit (ids) mainpc yoga; };
      thinkpad = { inherit (ids) thinkpad; };
      proserpina_1 = { inherit (ids) proserpina_1; };
      concordia = { inherit (ids) concordia; };
      all_handys = { inherit (ids) handyHannes handyMum handyDad tablet; };
      servers = { inherit (ids) syncschlawiner concordia dea; };
      all_servers = servers // {
        inherit (ids) tabula tabula_1 tabula_3 fons fabulinus;
      };

      #uni = { inherit stefan_handy sebastian_s_mac sebastian_r_laptop; };
    };
    folders = with devices;
      with devices.all_handys;
      with devices.all_servers;
      with devices.all_pcs; {
        "freshrss" = {
          folderToPathFunc = sharedFolderFn;
          devices = [ servers fons ];
        };
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

        "AnkiBackup" = {
          devices = [ (all_pcs // servers) ];
          folderToPathFunc = lib.mkIf (config.is_client)
            (_: "/home/hannses/.local/share/Anki2/User 1/backups");
        };
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
        "AlexandraWA" = {
          devices = [ (servers) "handyMum" yoga ];
          DirUsers = [ "mum" ];
        };
        "AlexandraKamera" = {
          devices = [ (servers) "handyMum" ];
          DirUsers = [ "mum" ];
        };
        "AlexandraGalerie" = {
          devices = [ (servers) "handyMum" ];
          DirUsers = [ "mum" ];
        };
        "ThomasKamera" = {
          devices = [ (servers) ];
          DirUsers = [ "dad" ];
        };
        "ThomasGalerie" = {
          devices = [ (servers) ];
          DirUsers = [ "dad" ];
        };
        "website" = {
          devices = [ (all_pcs) "tabula" tabula_1 tabula_3 ];
          paths.tabula = "/persist/website";
          paths.tabula_1 = "/persist/website";
          paths.tabula_3 = "/persist/website";
        };
        "esw-machines" = {
          devices = [ fabulinus proserpina_1 servers ];
          folderToPathFunc = sharedFolderFn;
        };
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
