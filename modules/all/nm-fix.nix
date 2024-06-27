{pkgs, ...}:{
systemd.services.NetworkManager-wait-online = {
  serviceConfig = {
    ExecStart = [ "" "${pkgs.networkmanager}/bin/nm-online -q" ];
  };
};
}
