{ lib, ... }:
{
  options = {
    fs-watchers.enable = lib.mkEnableOption "fs-watchers";
  };
  imports = [
    # keep-sorted start sticky_comments=no block=yes
    ./nextcloud_sync_fs.nix
    ./typst.nix
    ./xournalpp.nix
    # keep-sorted end
  ];
}
