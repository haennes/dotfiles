let eval = import ../../common/all/backup.nix {
      name = "home_backup";
      repository = "/mnt/backup/restic";
      passwordFile = "/mnt/backup/resticpasswd";
    };
in
{...}:{
  imports = [
    eval
  ];
}
