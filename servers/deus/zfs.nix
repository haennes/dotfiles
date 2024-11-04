{ lib, ... }: {
  networking.hostId = "d395beb7";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems = let inherit (lib) listToAttrs;
  in listToAttrs (map (n: {
    name = "/${n}";
    value = {
      device = "main_pool/${n}";
      fsType = "zfs";
    };
  }) [ "data" "website" "persistant" "ankisync" ]);
}
