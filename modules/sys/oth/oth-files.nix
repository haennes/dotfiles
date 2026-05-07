{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
in
{
  options.my.oth.files.enable = mkEnableOption "wether to add mounting command" // {
    default = config.my.oth.enable;
  };
  config = mkIf config.my.oth.files.enable {
    environment.systemPackages = [
      (import ../../../secrets/not_so_secret/mount_cmd_string.nix { inherit pkgs; })
    ];
  };
}
