{ lib, ... }:
{
  options = {
    fs-watchers.enable = lib.mkEnableOption "fs-watchers";
  };
  imports = [
              # keep-sorted start
    ./nextcloud_sync_fs.nix
    ./typst.nix
    ./xournalpp.nix
              # keep-sorted end
  ];
}
