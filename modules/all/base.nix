{ sshkeys, ... }:
{
  config = {

    users.users.root.openssh.authorizedKeys.keys = [ sshkeys.hannses ];
  };
}
