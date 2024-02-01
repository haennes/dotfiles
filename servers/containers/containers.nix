{config, pkgs, lib, ...}:
let hostName = "code.server.fritz.box"; in
{
  #containers.pterodactyl_panel = import ./pterodactyl.nix {config=config; pkgs=pkgs;};
  #containers.minecraft_school = import ./minecraft_school.nix {config=config; pkgs=pkgs;};
  #containers.nextcloud = import ./nextcloud.nix {config=config; pkgs=pkgs; lib=lib;};







  virtualisation.docker.enable = true;

  # services.nginx.virtualHosts.${hostName} = {
  #   enableACME = true;
  #   forceSSL = true;
  #   locations."/" = {
  #       proxyPass = "http://127.0.0.1:180";
  #       proxyWebsockets = true; # needed if you need to use WebSocket
  #       extraConfig =
  #         # required when the target is also TLS server with multiple hosts
  #         "proxy_ssl_server_name on;" +
  #         # required when the server wants to use HTTP Authentication
  #         "proxy_pass_header Authorization;"
  #         ;
  #     };
  # };

}