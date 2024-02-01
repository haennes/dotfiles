{pkgs, folder_local, folder_remote, server_address, user_remote, password, user_local, ...}:
let nc = import ./systemd_timer_service.nix {name="nextcloudcmd"; script = "${pkgs.nextcloud-client}/bin/nextcloudcmd -s --path ${folder_remote} ${folder_local} http://${user_remote}:${password}@${server_address}"; user=user_local; interval="2m";};
np = {pkgs, ...}: {
  environment.systemPackages = with pkgs; [ nextcloud-client ];
};
in
{
  imports = [ nc ];
}