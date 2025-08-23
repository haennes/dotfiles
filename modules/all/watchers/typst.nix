{ config, pkgs, lib, ... }:
let inherit (lib) mkEnableOption;
in {
  options = {
    fs-watchers.w.typst = (mkEnableOption "typst") // {
      default = config.fs-watchers.enable;
    };
  };
  config = lib.mkIf config.fs-watchers.w.typst {
    services.fs-watcher = {
      enable = true;
      directories = {
        ${config.services.syncthing.dataDir} = [{
          user = config.services.syncthing.user;
          match.include = ".*\\.typ$";
          command = "${pkgs.writeShellScript "n" ''
            ${pkgs.typst}/bin/typst c $3
          ''}";
          ifOutputOlder = "${pkgs.writeShellScript "n" ''
            echo $2 | sed 's/\.typ$/.pdf/'
          ''}";
        }];
      };
    };
  };
}
