{ sshkeys, ... }: {
  users.users.root.openssh.authorizedKeys.keys =
    [ sshkeys.hannses sshkeys.root_pve ];

  users.users.forward = {
    group = "forward";
    isNormalUser = true;
    openssh.authorizedKeys.keys =
      [ sshkeys.hannses sshkeys.root_pve sshkeys.forward ];
  };
  users.groups.forward = { };
}
