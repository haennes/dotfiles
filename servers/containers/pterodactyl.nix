{config, pkgs, ...}:{

  
  
  
  
  autoStart = true;
  privateNetwork = true;
  # hostAddress = "192.168.100.10";
  # localAddress = "192.168.100.11";
  # hostAddress6 = "fc00::1";
  # localAddress6 = "fc00::2";
  bindMounts = {
     "/docker-compose.yml"= {
      hostPath = builtins.toString ./docker-compose.yml;

    };
  };

  config  = { config, pkgs, ... }: {

    modules = [ airon.nixosModules.airon]

    networking.firewall.enable = false;
    
    networking.hostName = "pterodactyl_panel"

    environment.etc."resolv.conf".text = "nameserver 8.8.8.8";

    environment.systemPackages = with pkgs; [
    ];

    virtualisation.docker.enable = true;


    virtualisation.airon = {
      backend = "docker";
      projects = {
    
x-common:
  database:
    &db-environment
    # Do not remove the "&db-password" from the end of the line below, it is important
    # for Panel functionality.
    MYSQL_PASSWORD: &db-password "CHANGE_ME"
    MYSQL_ROOT_PASSWORD: "CHANGE_ME_TOO"
  panel:
    &panel-environment
    APP_URL: "http://nixos-server.fritz.box"
    # A list of valid timezones can be found here: http://php.net/manual/en/timezones.php
    APP_TIMEZONE: "Europe/Berlin"
    APP_SERVICE_AUTHOR: "noreply@example.com"
    # Uncomment the line below and set to a non-empty value if you want to use Let's Encrypt
    # to generate an SSL certificate for the Panel.
    # LE_EMAIL: ""
  mail:
    &mail-environment
    MAIL_FROM: "noreply@example.com"
    MAIL_DRIVER: "smtp"
    MAIL_HOST: "mail"
    MAIL_PORT: "1025"
    MAIL_USERNAME: ""
    MAIL_PASSWORD: ""
    MAIL_ENCRYPTION: "true"

#
# ------------------------------------------------------------------------------------------
# DANGER ZONE BELOW
#
# The remainder of this file likely does not need to be changed. Please only make modifications
# below if you understand what you are doing.
#
services:
  database:
    image: mariadb:10.5
    restart: always
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - "/srv/pterodactyl/database:/var/lib/mysql"
    environment:
      <<: *db-environment
      MYSQL_DATABASE: "panel"
      MYSQL_USER: "pterodactyl"
  cache:
    image: redis:alpine
    restart: always
  panel:
    image: ghcr.io/pterodactyl/panel:latest
    restart: always
    ports:
      - "80:80"
      - "443:443"
    links:
      - database
      - cache
    volumes:
      - "/srv/pterodactyl/var/:/app/var/"
      - "/srv/pterodactyl/nginx/:/etc/nginx/http.d/"
      - "/srv/pterodactyl/certs/:/etc/letsencrypt/"
      - "/srv/pterodactyl/logs/:/app/storage/logs"
    environment:
      <<: [*panel-environment, *mail-environment]
      DB_PASSWORD: *db-password
      APP_ENV: "production"
      APP_ENVIRONMENT_ONLY: "false"
      CACHE_DRIVER: "redis"
      SESSION_DRIVER: "redis"
      QUEUE_DRIVER: "redis"
      REDIS_HOST: "cache"
      DB_HOST: "database"
      DB_PORT: "3306"
networks:
  default:
    ipam:
      config:
        - subnet: 172.20.0.0/16
      }
    }









    # users.users.root = {
    #   extraGroups = [ "docker" ];
    # };

    # systemd.services.pterodactyl_docker  =  {
    #   path = [ pkgs.docker-compose ];
    #   script = ''
    #      docker-compose -f /docker-compose.yml
    #   '';
    #   wantedBy = ["multi-user.target"];
    #   after = ["docker.service" "docker.socket"];
    # };


    system.stateVersion = "22.05";

  };
}