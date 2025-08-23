{ config, pkgs, lib, ... }:
let
  user = config.services.syncthing.user;
  username = ((import ../../../secrets/not_so_secret/oth.nix).rzKennung);
  inherit (lib) mkEnableOption;
in {
  options = {
    fs-watchers.w.nc-sync = (mkEnableOption "nc sync") // {
      default = config.fs-watchers.enable;
    };
  };
  config = lib.mkIf config.fs-watchers.w.nc-sync {

    age.secrets."oth/rz.age" = {
      owner = user;
      file = ../../../secrets/oth/rz.age;
    };
    services.fs-watcher = {
      enable = true;
      directories = {
        "${config.services.syncthing.dataDir}/hannses__3d_printing/BarcodeHalter" =
          [{
            inherit user;
            match.include = "*";
            command = "${pkgs.writeShellScript "n" ''
              ${pkgs.nextcloud-client}/bin/nextcloudcmd -h --user ${username} --password "$(cat ${
                config.age.secrets."oth/rz.age".path
              })" --path /FSIM-Intern/Infra/digitale-strichliste BarcodeHalter https://cloud.fsim-ev.de
            ''}";
            ifOutputOlder = "${pkgs.writeShellScript "n" ''
              echo $2 | sed 's/\.typ$/.pdf/'
            ''}";
          }];
      };
    };
  };
}
