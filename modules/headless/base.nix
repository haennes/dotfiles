{sshkeys, ...}:{
   users.users.root.openssh.authorizedKeys.keys = [
     sshkeys.hannses
     sshkeys.root_pve
   ];
}
