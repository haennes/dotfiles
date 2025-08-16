{ config, pkgs, ... }: {
  services.fs-watcher = {
    enable = true;
    directories = {
      ${config.services.syncthing.dataDir} = [{
        user = config.services.syncthing.user;
        match.include = ".*\\.xopp$";
        command = "${pkgs.writeShellScript "n" ''
          ${pkgs.xournalpp}/bin/xournalpp $3 -p $(echo $3 | sed 's/\.xopp$/_annotated.pdf/') 
        ''}";
        ifOutputOlder = "${pkgs.writeShellScript "n" ''
          echo $2 | sed 's/\.xopp$/._annotated.pdf/'
        ''}";
      }];
    };
  };
}
