{
  sshkeys,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{

  options.my.users.forward.enable = mkEnableOption "add user forward" // {
    default = config.is_server;
  };
  config = mkIf config.my.users.forward.enable {
    users.users.forward = {
      group = "forward";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # keep-sorted start sticky_comments=no block=yes
        sshkeys.forward
        sshkeys.hannses
        sshkeys.root_pve
        # keep-sorted end
      ];
    };
    users.groups.forward = { };
  };
}
