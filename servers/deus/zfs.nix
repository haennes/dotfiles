{ ... }: {
  networking.hostId = "d395beb7";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems = {
    "/data" = {
      device = "main_pool/data";
      fsType = "zfs";
    };

    "/website" = {
      device = "main_pool/website";
      fsType = "zfs";
    };

    "/persistant" = {
      device = "main_pool/persistance";
      fsType = "zfs";
    };
    "/ankisync" = {
      device = "main_pool/ankisync";
      fsType = "zfs";
    };
  };
}
