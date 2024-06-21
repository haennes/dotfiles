{config, ...}:{
 services.kubo = {
    enable = true;
    dataDir = "/data/ipfs/data";
    user = "nextcloud";
    group = "nextcloud";
    enableGC = true;
    settings.Addresses.API = [
      "/ip4/127.0.0.1/tcp/8081"
    ];

    # the following might be a VFS, but still need to confirm
    #autoMount = true;
    #settings.Mounts = {
    #  IPFS =  "/data/ipfs/ipfs";
    #  IPNS =  "/data/ipfs/ipns";
    #};
  };
}
