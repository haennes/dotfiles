{lib, config, ...}:{
# the tasks ones are managed in tasks.nix

services.nginx = {
  enable = true;
  recommendedProxySettings = true;
  recommendedTlsSettings = true;
};
services.nginx.virtualHosts."localhost".locations = lib.mapAttrs(
  name: value: {proxyPass = "http://localhost:${toString value}";}){
#TODO make this auto-updating
"/syncschlawiner_syncthing" = 8385;
"/syncschlawiner_web_80" = 8386;
"/synscchlawiner_web_443" = 8387;
"/home" = config.services.homepage-dashboard.listenPort;
};
}
