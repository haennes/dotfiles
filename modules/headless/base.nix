{ sshkeys, ... }:
{

  users.users.forward = {
    group = "forward";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      # keep-sorted start
      sshkeys.forward
      sshkeys.hannses
      sshkeys.root_pve
      # keep-sorted end
    ];
  };
  users.groups.forward = { };
}
