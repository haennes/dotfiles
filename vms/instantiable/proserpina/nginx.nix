{ config, pkgs, ... }:
let
  repo_source = pkgs.fetchFromGitHub {
    owner = "Wulfheart";
    repo = "esw-machines";
    rev = "master";
    sha256 = "sha256-QfdVEImQJ5/zL4OBt41nHUi5wQnFBspYG2AmB684GOc=";
  };
  #website_source = pkgs.stdenv.mkDerivation {
  #  name = "esw-website";
  #  src = repo_source;
  #  phases = [ "unpackPhase" ];
  #  unpackPhase = ''
  #    mkdir $out
  #    cp $src/public $out -r
  #  '';
  #};
  website_dir = "/persist/website";

in {
  system.activationScripts."copy-website".text = ''
    cp -r ${repo_source}/public  ${website_dir}
    chown -R ${config.services.nginx.user}:${config.services.nginx.group} ${website_dir}
  '';
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "esw.hannses.de" = {
        root = website_dir;
        locations."~ \\.php$".extraConfig = ''
          fastcgi_pass  unix:${config.services.phpfpm.pools.esw.socket};
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
          include fastcgi_params;
        '';
      };
    };
  };
  services.phpfpm.pools.esw = {
    user = "nobody";
    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };
  };

  networking.firewall.interfaces.wg0.allowedTCPPorts =
    [ config.ports.ports.curr_ports.web ];

}
