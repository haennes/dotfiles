hostname:
{
  config,
  lib,
  pkgs,
  all_modules,
  ...
}:
let
  printer_user = "printer";
  pasv_port_range = {
    from = 51000;
    to = 51999;
  };
  sync_path = config.services.syncthing.settings.folders.${folder_name}.path;
  folder_name = "scan";
in
{
  imports = all_modules;

  is_server = true;
  is_client = false;
  is_microvm = true;
  services.syncthing-wrapper = {
    enable = true;
    isServer = true;
  };
  services.syncthing = {
    dataDir = "/persist";
    user = printer_user;
  };
  microvm.mem = 256;
  networking.hostName = hostname;

  services.wireguard-wrapper.enable = true;

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    userlistEnable = true;
    userlist = [ printer_user ];
    extraConfig = ''
      pasv_min_port=${builtins.toString pasv_port_range.from}
      pasv_max_port=${builtins.toString pasv_port_range.to}
    '';
    localUsers = true;
    chrootlocalUser = false;
    localRoot = sync_path;
  };
  security.pam.services.vsftpd.enable = true;

  users.users.${printer_user} = {
    home = sync_path;
    hashedPasswordFile = config.age.secrets."user-printer".path;
    extraGroups = ["ftp"];
    isNormalUser = true;
  };

  age.secrets."user-printer".file = ../../../secrets/user_passwords/printer.age;
  networking.firewall.allowedTCPPortRanges = [ pasv_port_range ];
  networking.firewall.allowedTCPPorts = [ 21 ];

  environment.systemPackages = with pkgs; [inetutils];

  services.syncthing-wrapper.folders.${folder_name}.users = [printer_user];
}

