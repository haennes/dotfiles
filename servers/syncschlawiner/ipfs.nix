{ hports, ... }: {
  networking.firewall.allowedTCPPorts = [ hports.ipfs.gateway ];
  services.kubo = {
    enable = false;
    dataDir = "/data/ipfs/data";
    user = "nextcloud";
    group = "nextcloud";
    enableGC = true;
    settings.Addresses = {
      API = [ "/ip4/127.0.0.1/tcp/${builtins.toString hports.ipfs.api}" ];
      Gateway =
        [ "/ip4/127.0.0.1/tcp/${builtins.toString hports.ipfs.gateway}" ];
    };

    # the following might be a VFS, but still need to confirm
    #autoMount = true;
    #settings.Mounts = {
    #  IPFS =  "/data/ipfs/ipfs";
    #  IPNS =  "/data/ipfs/ipns";
    #};
  };
}
