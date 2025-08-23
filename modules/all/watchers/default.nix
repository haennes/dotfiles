{ lib, ... }: {
  options = { fs-watchers.enable = lib.mkEnableOption "fs-watchers"; };
  imports = [ ./nextcloud_sync_fs.nix ./typst.nix ./xournalpp.nix ];
}
