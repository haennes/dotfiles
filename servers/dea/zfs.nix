{ config, lib, pkgs, ... }:
let
  zfssnap = pkgs.writeShellApplication {
    name = "zfssnap";
    checkPhase = ":"; # too many failed checks
    bashOptions = [ ]; # unbound variable $1
    text = ''
      date=$(date '+%Y-%m-%d-%H-%M-%S')
      ${pkgs.zfs}/bin/zfs snapshot -r main_pool@$date
    '';
  };

in {
  networking.hostId = "cd0745fd";
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems = (let inherit (lib) listToAttrs;
  in listToAttrs (map (n: {
    name = "/${n}";
    value = {
      device = "main_pool/${n}";
      fsType = "zfs";
      neededForBoot = false;
    };
  }) [ "data" "website" "ankisync" "kasmweb" "git" "persistant" ]));

  environment.systemPackages = [ zfssnap ];

  services.syncthing_wrapper = { enable = true; };

  system.activationScripts.ensure-syncthing-dir = ''
    mkdir -p /data
    chown -R ${config.services.syncthing.user}:${config.services.syncthing.user} /data
  '';
  services.syncthing = { dataDir = "/data"; };
}
