{ sshkeys, ... }:
{

  users.users.forward = {
    group = "forward";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
              # keep-sorted start
      sshkeys.hannses
      sshkeys.root_pve
      sshkeys.forward
              # keep-sorted end
    ];
  };
  users.groups.forward = { };
}
