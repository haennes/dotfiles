{ sshkeys, ... }:
{
  config = {

    networking.firewall.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [ sshkeys.hannses ];
  };
}
