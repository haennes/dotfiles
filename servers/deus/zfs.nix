{ lib, ... }: {
  networking.hostId = "d395beb7";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems = (let inherit (lib) listToAttrs;
  in listToAttrs (map (n: {
    name = "/${n}";
    value = {
      device = "main_pool/${n}";
      fsType = "zfs";
    };
  }) [ "data" "website" "ankisync" "kasmweb" "git" ]) // {
    "persistance" = {
      device = "main_pool/persistant";
      fsType = "zfs";
    };
  });
}
