{ config, ... }:
let
  filesDir = "/persist/files";
  filesUser = config.services.nginx.user;
  hostname = config.networking.hostName;
in {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "storage.actions.local.hannses.de" = {
        # https disabled because it is only used internally
        root = filesDir;
        listenAddresses = [ config.ips.ips.ips.default.${hostname}.wg0 ];
      };
    };
  };

  services.vsftpd = {
    enable = true;
    userlistDeny = false;
    localUsers = true;
    userlist = [ filesUser ];
    rsaCertFile = config.age.secrets."vsftpd/${hostname}".path;
    writeEnable = true;
    localRoot = filesDir;
  };

  age.secrets."vsftpd/${hostname}" = {
    owner = "vsftpd";
    file = ../../../secrets/vsftpd/${hostname}/cert.age;
  };

  users.users.nginx = {
    extraGroups = [ "vsftpd" ];
    hashedPasswordFile = config.age.secrets."user_passwords/nginx.age".path;
  };

  age.secrets."user_passwords/nginx.age".file =
    ../../../secrets/vsftpd/${hostname}/cert.age;

  systemd.tmpfiles.rules = [ "d ${filesDir} 2770 vsftpd vsftpd - -" ];
  networking.firewall = {
    allowedTCPPorts = [ 80 21 20 ];
    allowedTCPPortRanges = [{
      from = 51000;
      to = 51999;
    }];
  };

}
