{ config, ... }:
let
  pasv_port_range = {
    from = 51000;
    to = 51999;
  };
  printer_user = "printer";
  folder_name = "scan";
in {
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    userlistEnable = true;
    userlist = [ printer_user ];
    extraConfig = ''
      pasv_enable = true
      pasv_min_port=${pasv_port_range.from}
      pasv_max_port=${pasv_port_range.to}
    '';
    localUsers = true;
    chrootlocalUser = true;
  };

  users.users.${printer_user}.home =
    config.services.syncthing.settings.folders.${folder_name}.path;
  networking.firewall.allowedTCPPortRanges = [ pasv_port_range ];
  networking.firewall.allowedTCPPorts = [ 21 ];
}
