{ config, lib, ... }:
let
  inherit (lib)
    mapAttrs attrNames head splitString tail optional concatStringsSep;
  splitStringOnce = sep: str:
    let
      sp = (splitString sep str);
      first = head sp;
      second = (concatStringsSep sep (tail sp));
    in [ first ] ++ optional (second != "") second;
  #TODO move to own lib
  ids = import ../../secrets/not_so_secret/syncthing.key.nix;
  ids_attrs = mapAttrs (_: v: { id = v; }) ids;
  #sharedFolderFn = { folder_name, DirUsers, DirGroups }:
  #  "${config.services.syncthing.dataDir}/${folder_name}";
  #family_if_client = (if (config.is_client) then {
  #  DirGroups = [ "family" ];
  #  ensureDirExists = "setfacl";
  #} else
  #  { });
  devices = rec {
    all_pcs = { inherit (ids_attrs) mainpc yoga; };
    all_pcs_minimal = all_pcs // { inherit (ids_attrs) thinknew thinkpad; };
    all_handys = { inherit (ids_attrs) handyHannes handyMum handyDad tablet; };
    servers = { inherit (ids_attrs) dea; };
    all_servers = servers // {
      inherit (ids_attrs) tabula tabula_1 tabula_3 proserpina_1 fons fabulinus;
    };

    #uni = { inherit stefan_handy sebastian_s_mac sebastian_r_laptop; };
  } // ids_attrs;
in {
  imports = [ ./syncthing_wrapper_secrets.nix ];
  services.syncthing-wrapper = {
    secrets = {
      keyFunction = hostname:
        config.age.secrets."syncthing_key_${hostname}".path;
      certFunction = hostname:
        lib.mkIf (config.services.syncthing.enable)
        config.age.secrets."syncthing_cert_${hostname}".path;
    };
    defaultEnsure = lib.mkIf config.is_client {
      DirExists = true;
      group = {
        group = true;
        recursive = false;
      };
      owner = {
        owner = true;
        recursive = false;
      };
    };
    defaultVersioning.simple.params.keep = 10;
    servers = attrNames devices.all_servers;
    pseudoGroups."family" = [ "hannses" "mum" "dad" ];
    legacyIDMap = {
      "hannses__freshrss" = "freshrss";
      "hannses__AnkiBackup" = "AnkiBackup";
      "hannses__3d_printing" = "3d_printing";
      "hannses__Documents" = "Documents";
      "hannses__Notes" = "Notes";
      "hannses__tasks" = "tasks";
      "hannses__Downloads" = "Downloads";
      "hannses__Music" = "Music";
      "hannses__Templates" = "Templates";
      "hannses__Videos" = "Videos";
      "hannses__game_servers" = "game_servers";
      "hannses__programming" = "programming";
      "hannses__AegisBak" = "AegisBak";
      "hannses__AntennaBak" = "AntennaBak";
      "hannses__SignalBackup" = "SignalBackup";
      "hannses__DownloadHandy" = "DownloadHandyH";
      "hannses__Kamera" = "HannesKamera";
      "hannses__Galerie" = "HannesGalerie";
      "mum__WA" = "AlexandraWA";
      "mum__Kamera" = "AlexandraKamera";
      "mum__Galerie" = "AlexandraGalerie";
      "dad__Kamera" = "ThomasKamera";
      "dad__Galerie" = "ThomasGalerie";
      "hannses__website" = "website";
      "esw-machine__esw-machines" = "esw-machines";
    };
    paths = {
      users = {
        userDirFolderMap = {
          hannses.AnkiBackup =
            "/home/hannses/.local/share/Anki2/User 1/backups";
        };
        defaultUserDir = "/home";
      };
    };
    idToOptionalUserName = folderId:
      let
        v = head (splitStringOnce "__" folderId);
        cfg = config.services.syncthing-wrapper;
      in if v == (cfg.idToTargetName folderId) then null else v;
    folders = with devices;
      with devices.all_handys;
      with devices.all_servers;
      with devices.all_pcs; {
        "hannses__freshrss".devices = { inherit fons; } // servers;
        "Family" = {
          devices = all_pcs // servers // { inherit thinkpad; };
          pseudoGroups = [ "family" ];
        };
        "Passwords" = {
          devices = all_pcs_minimal // all_handys // servers // {
            inherit thinkpad;
          };
          versioning.type.simple.params.keep = 100;
          pseudoGroups = [ "family" ];
        };

        "hannses__AnkiBackup".devices = all_pcs_minimal // servers;
        "hannses__3d_printing".devices = all_pcs_minimal // servers;
        "hannses__Documents".devices = all_pcs_minimal // servers;
        "hannses__Notes".devices = all_pcs_minimal // servers;
        "hannses__tasks".devices = all_pcs_minimal // servers;
        "hannses__Downloads".devices = all_pcs_minimal // servers;
        "hannses__Music".devices = all_pcs // servers;
        "Pictures" = {
          devices = servers // all_pcs;
          pseudoGroups = [ "family" ];
        };
        "hannses__Templates".devices = all_pcs_minimal // servers;
        "hannses__Videos".devices = all_pcs // servers;
        "hannses__game_servers".devices = all_pcs // servers;
        "hannses__programming".devices = all_pcs // servers;
        "hannses__AegisBak".devices = {
          inherit handyHannes;
        } // all_pcs_minimal // servers;
        "hannses__AntennaBak".devices = {
          inherit handyHannes;
        } // all_pcs_minimal // servers;
        "hannses__SignalBackup".devices = { inherit handyHannes; } // servers;
        "hannses__DownloadHandy".devices = {
          inherit handyHannes;
        } // all_pcs_minimal // servers;
        "hannses__Kamera".devices = {
          inherit handyHannes;
        } // all_pcs // servers;
        "hannses__Galerie".devices = {
          inherit handyHannes;
        } // all_pcs // servers;
        "mum__WA".devices = { inherit handyMum yoga; } // servers;
        "mum__Kamera".devices = { inherit handyMum; } // servers;
        "mum__Galerie".devices = { inherit handyMum; } // servers;
        "dad__Kamera".devices = servers;
        "dad__Galerie".devices = servers;
        "hannses__website".devices = {
          inherit tabula tabula_1 tabula_3;
        } // all_pcs_minimal;
        "esw-machine__esw-machines".devices = {
          inherit fabulinus proserpina_1;
        } // servers;
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
  };
}
