{ ... }: {
  networking.hostId = "d395beb7";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems."/data" = {
    device = "main_pool/data";
    fsType = "zfs";
  };
}
